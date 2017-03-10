class CalcStat
  attr_reader :from, :to

  def initialize(from, to, ip)
    from = from.dup.strip
    to = to.dup.strip
    @from = from =~ /\A\d+\z/ ? Time.at(from.to_i) : Time.parse(from)
    @to = to =~ /\A\d+\z/ ? Time.at(to.to_i) : Time.parse(to)
  end
end
