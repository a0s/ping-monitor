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
    it { expect(CalcStat.new('1489177202', '1489173602', ip).from.to_s).to eq '2017-03-10 20:20:02 +0000' }
    it { expect(CalcStat.new('1489177202', '1489173602', ip).to.to_s).to eq '2017-03-10 19:20:02 +0000' }
    it { expect(CalcStat.new('2017-03-10 23:23:54 +0000', '2017-03-10 23:23:54 +0000', ip).from.to_s).to eq '2017-03-10 23:23:54 +0000' }
    it { expect(CalcStat.new('2017-03-10 23:23:54 +0000', '2017-03-10 22:23:54 +0000', ip).to.to_s).to eq '2017-03-10 22:23:54 +0000' }
    it { expect(CalcStat.new('2017-03-10 23:23:54', '2017-03-10 22:23:54', ip).from.to_s).to eq '2017-03-10 23:23:54 +0000' }
    it { expect(CalcStat.new('2017-03-10 23:23:54', '2017-03-10 22:23:54', ip).to.to_s).to eq '2017-03-10 22:23:54 +0000' }
    it { expect(CalcStat.new('2017-03-10', '2017-03-10', ip).from.to_s).to eq '2017-03-10 00:00:00 +0000' }
    it { expect(CalcStat.new('2017-03-10', '2017-03-10', ip).to.to_s).to eq '2017-03-10 00:00:00 +0000' }
  end
end
