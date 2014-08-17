class ISO8601::Duration

  attr_reader :years, :months, :weeks, :days, :hours, :minutes, :seconds, :sign

  def initialize(value)
    match = /^(\+|-)? # Sign
     P(
        (
          (\d+(?:[,.]\d+)?Y)? # Years
          (\d+(?:[.,]\d+)?M)? # Months
          (\d+(?:[.,]\d+)?D)? # Days
          (T
            (\d+(?:[.,]\d+)?H)? # Hours
            (\d+(?:[.,]\d+)?M)? # Minutes
            (\d+(?:[.,]\d+)?S)? # Seconds
          )? # Time
        )
        |(\d+(?:[.,]\d+)?W) # Weeks
      ) # Duration
    $/x.match(value)

    raise ArgumentError, 'invalid duration' unless match

    @sign = (match[1] == '-' ? -1 : 1)
    { years: 4, months: 5, weeks: 11, days: 6, hours: 8, minutes: 9, seconds: 10 }.each do |key, index|
      instance_variable_set "@#{key}", match[index] ? match[index].chop.to_f * @sign : 0 
    end
  end

  def present?
    ! blank?
  end

  def blank?
    empty?
  end

  def empty?
    to_h.all? { |key, value| value.zero? }
  end

  def iso8601
    return nil if blank?

    day_parts = [:years, :months, :weeks, :days].collect do |key|
      value = to_h[key].divmod(1)[1].zero?? to_h[key].to_i : to_h[key]
      "#{value}#{key.to_s[0].upcase}" unless value.zero?
    end.compact

    time_parts = [:hours, :minutes, :seconds].collect do |key|
      value = to_h[key].divmod(1)[1].zero?? to_h[key].to_i : to_h[key]
      "#{value}#{key.to_s[0].upcase}" unless value.zero?
    end.compact

    "P#{day_parts.join}#{time_parts.any?? "T#{time_parts.join}" : ''}"
  end

  def eql?(other)
    self.hash == other.hash
  end

  def ==(other)
    eql? other
  end

  def hash
    [self.class, to_h.to_a].hash
  end

  def inspect
    "#<#{self.class.name}: #{to_s}>"
  end

  def to_s
    singular = {
      years:   'year',
      months:  'month',
      weeks:   'week',
      days:    'day',
      hours:   'hour',
      minutes: 'minute',
      seconds: 'second' }

    to_h.collect do |key, value|
      value = value.divmod(1)[1].zero?? value.to_i : value
      value.zero?? nil : key == 1.0 ? "#{value} #{singular[key]}" : "#{value} #{key}"
    end.compact.join(', ')
  end

  def to_f
    { years:   31536000,
      months:  2628000,
      weeks:   604800,
      days:    86400,
      hours:   3600,
      minutes: 60,
      secodns: 1 }.collect do |key, value|
        to_h[key] * value
      end.sum
  end

  def to_i
    to_f.to_i
  end

  def to_h
    { years:   @years,
      months:  @months,
      weeks:   @weeks,
      days:    @days,
      hours:   @hours,
      minutes: @minutes,
      seconds: @seconds }
  end
end