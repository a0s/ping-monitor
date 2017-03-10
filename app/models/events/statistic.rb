class Statistic < Event
  many_to_one :ip

  def validate
    super
    validates_numeric :latency, allow_nil: false
  end
end
