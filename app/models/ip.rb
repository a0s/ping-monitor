class Ip < Sequel::Model
  one_to_many :events
  one_to_many :enables
  one_to_many :statistics
  one_to_many :disables

  subset(:enabled) { {enabled: true} }
  subset(:not_checking_now) { {start_checking_at: nil} }
  subset(:its_time_to_check) { last_checked_at <= Time.now - App.config.ping_interval }

  def after_create
    super
    Enable.create(ip_id: id)
  end
end
