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

    from_pg = @from.strftime('%Y-%m-%d %H:%M:%S.%6N%z')
    to_pg = @to.strftime('%Y-%m-%d %H:%M:%S.%6N%z')
    mm = %Q(
    SELECT CASE WHEN c % 2 = 0 AND c > 1 THEN (a[1]+a[2])/2 ELSE a[1] END
    FROM (
    SELECT ARRAY(SELECT latency FROM events WHERE (
    (latency is not null) AND
    ("ip_id" = #{@ip.id}) AND
    ("created_at" >= '#{from_pg}') AND
    ("created_at" <= '#{to_pg}')
    )ORDER BY created_at OFFSET (c-1)/2 LIMIT 2) AS a, c
    FROM (SELECT count(*) AS c FROM events WHERE (
    (latency is not null) AND
    ("ip_id" = #{@ip.id}) AND
    ("created_at" >= '#{from_pg}') AND
    ("created_at" <= '#{to_pg}')
    ) ) AS count
    OFFSET 0
    ) AS midrows)
    result[:med] = DB[mm].map(:a)[0]
    result
  end
end
