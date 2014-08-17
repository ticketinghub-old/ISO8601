class ISO8601::Date < ::Date

  def self.new(*args)
    case value = args[0]
    when Numeric then super
    when String
      dt = ::Date.iso8601 value
      super dt.year, dt.month, dt.day
    else super end
  end

  def +(other)
    case other
    when ISO8601::Time
      ISO8601::DateTime.new self.year, self.month, self.day,
        other.hour, other.minute, other.second, other.zone
    when ISO8601::Duration
      { years: [:>>, 12], months: [:>>, 1], weeks: [:+, 7], days: [:+, 1] }.reduce self do |date, (key, (action, factor))|
        date.send action, other.to_h[key] * factor
      end
    else super end
  end
end