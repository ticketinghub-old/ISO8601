class ISO8601::Time < ::DateTime

  def self.new(*args)
    case value = args[0]
    when Numeric
      super 2000, 1, 1, *args
    when String
      value = "T#{value}" unless value.starts_with? 'T'
      dt = ::DateTime.iso8601 "2000-01-01#{value}"
      super 2000, 1, 1, dt.hour, dt.minute, dt.second, dt.zone
    else super end
  end

  def +(other)
    case other
    when ISO8601::Date
      ISO8601::DateTime.new other.year, other.month,
        other.day, self.hour, self.minute, self.second, self.zone
    when ISO8601::Duration
      seconds = slice[:hours, :minutes, :seconds].collect do |key|
        { seconds: 1, minutes: 60, hours: 3600 }[key] * other.to_h[key]
      end.sum
      super Rational(seconds.round, 86400)
    else super end
  end
end