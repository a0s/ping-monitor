class CalcStat
  attr_reader :from, :to

  def self.calc_all_time(ip)
    ip_obj = ip.is_a?(Ip) ? ip : Ip.find(ip: ip)
    if ip_obj.events_dataset.stat_or_fail.count == 0
      return {total: 0}
    end
    from = ip_obj.events_dataset.stat_or_fail.min(:created_at).to_s
    to = ip_obj.events_dataset.stat_or_fail.max(:created_at).to_s
    new(ip, from, to).calc
  end

  def initialize(ip, from, to)
    @ip = ip.is_a?(Ip) ? ip : Ip.find(ip: ip)

    if from.is_a?(Fixnum) || from.to_s =~ /\A\d+\z/
      @from = Time.at(from.to_i)
    else
      @from = Time.parse(from.to_s)
    end

    if to.is_a?(Fixnum) || to.to_s =~ /\A\d+\z/
      @to = Time.at(to.to_i)
    else
      @to = Time.parse(to.to_s)
    end
  end

  def calc
    result = {}
    result[:fails] = Fail.where(ip_id: @ip.id, created_at: @from..@to).count
    result[:stats] = Statistic.where(ip_id: @ip.id, created_at: @from..@to).count
    result[:total] = result[:stats] + result[:fails]
    return {total: 0} if result[:total] == 0
    result[:fails_percent] = result[:fails].to_f / result[:total] * 100

    k = [:avg, :min, :max, :sdv]
    r = Statistic.
        where(ip_id: @ip.id, created_at: @from..@to).
        select { [avg(:latency).as(:avg),
                  min(:latency).as(:min),
                  max(:latency).as(:max),
                  stddev(:latency).as(:sdv)] }
    result.merge!(Hash[k.zip(r.map(k)[0])])
    result[:sdv] ||= 0.0

    if result[:stats] == 0
      result[:med] = nil
    else
      if result[:stats] % 2 == 0
        a, b = Statistic.
            where(ip_id: @ip.id, created_at: @from..@to).
            order(:latency).
            limit(2, (result[:stats] - 1) / 2).all
        result[:med] = (a.latency + b.latency) / 2
      else
        a = Statistic.
            where(ip_id: @ip.id, created_at: @from..@to).
            order(:latency).
            limit(1, result[:stats] / 2).all
        result[:med] = a[0].latency
      end
    end
    result
  end
end
