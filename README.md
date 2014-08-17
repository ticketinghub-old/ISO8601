# ISO8601

ISO8601 is a simple implementation of the ISO 8601 (Data elements and
interchange formats — Information interchange — Representation of dates and
times) standard.

## Build status

[![Build Status](https://secure.travis-ci.org/arnau/ISO8601.png?branch=master)](http://travis-ci.org/arnau/ISO8601/)

## Supported versions

* MRI 1.9.3
* MRI 2.0
* MRI 2.1
* RBX 2

Check the [changelog](https://github.com/arnau/ISO8601/blob/master/CHANGELOG.md) if you are upgrading from an older version.


## Comments about this implementation

### Duration sign

Because Durations and DateTime has a substraction method, Durations has
sign to be able to represent a negative value:

    (ISO8601::Duration.new('PT10S') - ISO8601::Duration.new('PT12S')).to_s  #=> '-PT2S'
    (ISO8601::Duration.new('-PT10S') + ISO8601::Duration.new('PT12S')).to_s #=> 'PT2S'


## Differences with core Date, Time and DateTime

Core `Date.parse` and `DateTime.parse` doesn't allow reduced precision. For
example:

    DateTime.parse('2014-05') # => ArgumentError: invalid date

But the standard covers this situation assuming any missing piece as its lower
value:

    ISO8601::DateTime.new('2014-05').to_s # => "2014-05-01T00:00:00+00:00"
    ISO8601::DateTime.new('2014').to_s # => "2014-01-01T00:00:00+00:00"

The same assumption happens in core classes with `.new`:

    DateTime.new(2014,5) # => #<DateTime: 2014-05-01T00:00:00+00:00 ((2456779j,0s,0n),+0s,2299161j)>
    DateTime.new(2014) # => #<DateTime: 2014-01-01T00:00:00+00:00 ((2456659j,0s,0n),+0s,2299161j)>


The value of second in core classes are handled by two methods: `#second` and
`#second_fraction`:

    dt = DateTime.parse('2014-05-06T10:11:12.5')
    dt.second # => 12
    dt.second_fraction # => (1/2)

This gem approaches second fraction using floats:

    dt = ISO8601::DateTime.new('2014-05-06T10:11:12.5')
    dt.second # => 12.5

Unmatching precison is handled strongly. Notice the time fragment is lost in
`DateTime.parse` without warning only if the loose precision is in the time
component.

    ISO8601::DateTime.new('2014-05-06T101112')  # => ArgumentError
    DateTime.parse('2014-05-06T101112')  # => #<DateTime: 2014-05-06T00:00:00+00:00 ((2456784j,0s,0n),+0s,2299161j)>

    ISO8601::DateTime.new('20140506T10:11:12')  # => ArgumentError
    DateTime.parse('20140506T10:11:12')  # => #<DateTime: 2014-05-06T10:11:12+00:00 ((2456784j,0s,0n),+0s,2299161j)>


`DateTime#to_a` allow decomposing to an array of atoms:

    atoms = ISO8601::DateTime.new('2014-05-31T10:11:12Z').to_a # => [2014, 5, 31, 10, 11, 12, '+00:00']
    dt = DateTime.new(*atoms)

Ordinal dates keep the sign. `2014-001` is not the same as `-2014-001`.

Week dates raise an error when two digit days provied instead of return monday:

    ISO8601::DateTime.new('2014-W15-02') # => ArgumentError
    DateTime.new('2014-W15-02')  # => #<Date: 2014-04-07 ((2456755j,0s,0n),+0s,2299161j)>


## Contributing

[Contributors](https://github.com/arnau/ISO8601/graphs/contributors)

1. Fork it (http://github.com/arnau/ISO8601/fork)
2. Create your feature branch (git checkout -b features/xyz)
3. Commit your changes (git commit -am 'Add XYZ')
4. Push to the branch (git push origin features/xyz)
5. Create new Pull Request


## License

Arnau Siches under the [MIT License](https://github.com/arnau/ISO8601/blob/master/LICENSE)
