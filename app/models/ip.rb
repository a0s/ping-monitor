class Ip < Sequel::Model
  ORPHANED_THRESHOLD = 3.seconds

  one_to_many :events
  one_to_many :enables
  one_to_many :statistics
  one_to_many :disables

  subset(:enabled) { {enabled: true} }
  subset(:disabled) { {enabled: false} }
  subset(:not_checking_now) { {start_checking_at: nil} }
  subset(:its_time_to_check) { last_checked_at <= Time.now - App.config.ping_interval }
  subset(:orphaned) { start_checking_at < Time.now - App.config.ping_timeout - ORPHANED_THRESHOLD }

  def after_create
    super
    Enable.create(ip_id: id)
  end

  def enable!
    update(enabled: true)
  end

  def disable!
    update(enabled: false)
  end

  def self.clean_orphaned!
    self.orphaned.update(start_checking_at: nil)
  end
end
