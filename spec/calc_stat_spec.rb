require File.dirname(__FILE__) + '/spec_helper'

describe CalcStat do
  describe '#initializer' do
    let(:ip) { '1.1.1.1' }
    before(:all) do
      @tz = Time.now.getlocal.zone
      @tz_env = ENV['TZ']
      ENV['TZ'] = 'UTC'
    end
    after(:all) do
      ENV['TZ'] = @tz_env
    end
    it { expect(CalcStat.new(ip, 1489177202, 1489173602).from.to_s).to eq '2017-03-10 20:20:02 +0000' }
    it { expect(CalcStat.new(ip, 1489177202, 1489173602).to.to_s).to eq '2017-03-10 19:20:02 +0000' }
    it { expect(CalcStat.new(ip, '1489177202', '1489173602').from.to_s).to eq '2017-03-10 20:20:02 +0000' }
    it { expect(CalcStat.new(ip, '1489177202', '1489173602').to.to_s).to eq '2017-03-10 19:20:02 +0000' }
    it { expect(CalcStat.new(ip, '2017-03-10 23:23:54 +0000', '2017-03-10 23:23:54 +0000').from.to_s).to eq '2017-03-10 23:23:54 +0000' }
    it { expect(CalcStat.new(ip, '2017-03-10 23:23:54 +0000', '2017-03-10 22:23:54 +0000').to.to_s).to eq '2017-03-10 22:23:54 +0000' }
    it { expect(CalcStat.new(ip, '2017-03-10 23:23:54', '2017-03-10 22:23:54').from.to_s).to eq '2017-03-10 23:23:54 +0000' }
    it { expect(CalcStat.new(ip, '2017-03-10 23:23:54', '2017-03-10 22:23:54').to.to_s).to eq '2017-03-10 22:23:54 +0000' }
    it { expect(CalcStat.new(ip, '2017-03-10', '2017-03-10').from.to_s).to eq '2017-03-10 00:00:00 +0000' }
    it { expect(CalcStat.new(ip, '2017-03-10', '2017-03-10').to.to_s).to eq '2017-03-10 00:00:00 +0000' }
  end

  describe '#calc' do
    describe '0 samples' do
      before { ip = Ip.create(ip: '1.2.3.4') }
      it { expect(CalcStat.new('1.2.3.4', Time.at(0), Time.at(500)).calc).to eq(:total => 0) }
    end

    describe '1 sample' do
      before do
        ip = Ip.create(ip: '1.2.3.4')
        Statistic.create(ip_id: ip.id, created_at: Time.at(100), latency: 4.5)
      end
      it { expect(CalcStat.new('1.2.3.4', Time.at(0), Time.at(500)).calc).to eq(:fails => 0,
                                                                                :stats => 1,
                                                                                :total => 1,
                                                                                :fails_percent => 0.0,
                                                                                :avg => 4.5,
                                                                                :min => 4.5,
                                                                                :max => 4.5,
                                                                                :sdv => 0.0,
                                                                                :med => 4.5) }
    end

    describe '4 samples' do
      before do
        ip = Ip.create(ip: '1.2.3.4')
        Statistic.create(ip_id: ip.id, created_at: Time.at(100), latency: 4.5)
        Statistic.create(ip_id: ip.id, created_at: Time.at(200), latency: 3.2)
        Statistic.create(ip_id: ip.id, created_at: Time.at(300), latency: 2.9)
        Statistic.create(ip_id: ip.id, created_at: Time.at(400), latency: 3.5)
      end
      it { expect(CalcStat.new('1.2.3.4', Time.at(0), Time.at(500)).calc).to eq(:fails => 0,
                                                                                :stats => 4,
                                                                                :total => 4,
                                                                                :fails_percent => 0.0,
                                                                                :avg => 3.525,
                                                                                :min => 2.9,
                                                                                :max => 4.5,
                                                                                :sdv => 0.694622199472491,
                                                                                :med => 3.35) }
    end

    describe 'some fails' do
      before do
        ip = Ip.create(ip: '1.2.3.4')
        Statistic.create(ip_id: ip.id, created_at: Time.at(100), latency: 4.5)
        Fail.create(ip_id: ip.id, created_at: Time.at(200))
        Statistic.create(ip_id: ip.id, created_at: Time.at(300), latency: 2.9)
        Statistic.create(ip_id: ip.id, created_at: Time.at(400), latency: 3.5)
        Fail.create(ip_id: ip.id, created_at: Time.at(420))
      end
      it { expect(CalcStat.new('1.2.3.4', Time.at(0), Time.at(500)).calc).to eq(:fails => 2,
                                                                                :stats => 3,
                                                                                :total => 5,
                                                                                :fails_percent => 40.0,
                                                                                :avg => 3.63333333333333,
                                                                                :min => 2.9,
                                                                                :max => 4.5,
                                                                                :sdv => 0.808290376865475,
                                                                                :med => 3.5) }
    end

    describe 'all fails' do
      before do
        ip = Ip.create(ip: '1.2.3.4')
        Fail.create(ip_id: ip.id, created_at: Time.at(100))
        Fail.create(ip_id: ip.id, created_at: Time.at(200))
        Fail.create(ip_id: ip.id, created_at: Time.at(300))
        Fail.create(ip_id: ip.id, created_at: Time.at(400))
      end
      it { expect(CalcStat.new('1.2.3.4', Time.at(0), Time.at(500)).calc).to eq(:fails => 4,
                                                                                :stats => 0,
                                                                                :total => 4,
                                                                                :fails_percent => 100.0,
                                                                                :avg => nil,
                                                                                :min => nil,
                                                                                :max => nil,
                                                                                :sdv => 0.0,
                                                                                :med => nil) }
    end

    describe '4 samples with other samples' do
      before do
        ip = Ip.create(ip: '1.2.3.4')
        Statistic.create(ip_id: ip.id, created_at: Time.at(100), latency: 4.5)
        Statistic.create(ip_id: ip.id, created_at: Time.at(200), latency: 3.2)
        Statistic.create(ip_id: ip.id, created_at: Time.at(300), latency: 2.9)
        Statistic.create(ip_id: ip.id, created_at: Time.at(400), latency: 3.5)
        ip2 = Ip.create(ip: '5.6.7.8')
        Statistic.create(ip_id: ip2.id, created_at: Time.at(120), latency: 1.2)
        Statistic.create(ip_id: ip2.id, created_at: Time.at(220), latency: 10.3)
        Statistic.create(ip_id: ip2.id, created_at: Time.at(330), latency: 1.3)
      end
      it { expect(CalcStat.new('1.2.3.4', Time.at(0), Time.at(500)).calc).to eq(:fails => 0,
                                                                                :stats => 4,
                                                                                :total => 4,
                                                                                :fails_percent => 0.0,
                                                                                :avg => 3.525,
                                                                                :min => 2.9,
                                                                                :max => 4.5,
                                                                                :sdv => 0.694622199472491,
                                                                                :med => 3.35) }
      it { expect(CalcStat.new('5.6.7.8', Time.at(0), Time.at(500)).calc).to eq(:fails => 0,
                                                                                :stats => 3,
                                                                                :total => 3,
                                                                                :fails_percent => 0.0,
                                                                                :avg => 4.26666666666667,
                                                                                :min => 1.2,
                                                                                :max => 10.3,
                                                                                :sdv => 5.22525916422653,
                                                                                :med => 1.3) }
    end
  end

  describe '.calc_all_time' do
    before { ip = Ip.create(ip: '5.5.3.1') }
    it { expect(CalcStat.calc_all_time('5.5.3.1')).to eq(total: 0) }
  end
end
