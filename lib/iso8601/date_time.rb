class ISO8601::DateTime < ::DateTime

  def self.new(*args)
    case value = args[0]
    when Numeric then super
    when String
      dt = ::DateTime.iso8601 value
      super dt.year, dt.month, dt.day,
        dt.hour, dt.minute, dt.second, dt.zone
    else super end
  end

  def to_iso8601_date
    ISO8601::Date.new year, month, day
  end

  def to_iso8601_time
    ISO8601::Time.new hour, minute, second, zone
  end

  def +(other)
    case other
    when ISO8601::Duration
      date = to_iso8601_date + other
      time = to_iso8601_time + other
      date + time
    else super end
  end
end