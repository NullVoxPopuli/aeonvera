dry-equalizer
=========

Module to define equality, equivalence and inspection methods

[![Gem Version](http://img.shields.io/gem/v/equalizer.svg)][gem]
[![Build Status](http://img.shields.io/travis/dryrb/dry-equalizer.svg)][travis]
[![Dependency Status](http://img.shields.io/gemnasium/dryrb/dry-equalizer.svg)][gemnasium]
[![Code Climate](http://img.shields.io/codeclimate/github/dryrb/dry-equalizer.svg)][codeclimate]

[gem]: https://rubygems.org/gems/equalizer
[travis]: https://travis-ci.org/dryrb/dry-equalizer
[gemnasium]: https://gemnasium.com/dryrb/dry-equalizer
[codeclimate]: https://codeclimate.com/github/dryrb/dry-equalizer

Examples
--------

``` ruby
class GeoLocation
  include Equalizer.new(:latitude, :longitude)

  attr_reader :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude, @longitude = latitude, longitude
  end
end

point_a = GeoLocation.new(1, 2)
point_b = GeoLocation.new(1, 2)
point_c = GeoLocation.new(2, 2)

point_a.inspect    # => "#<GeoLocation latitude=1 longitude=2>"

point_a == point_b           # => true
point_a.hash == point_b.hash # => true
point_a.eql?(point_b)        # => true
point_a.equal?(point_b)      # => false

point_a == point_c           # => false
point_a.hash == point_c.hash # => false
point_a.eql?(point_c)        # => false
point_a.equal?(point_c)      # => false
```

Supported Ruby Versions
-----------------------

This library aims to support and is [tested against][travis] the following Ruby
implementations:

* Ruby 2.1
* Ruby 2.2

If something doesn't work on one of these versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby versions or
implementations, however support will only be provided for the implementations
listed above.

If you would like this library to support another Ruby version or
implementation, you may volunteer to be a maintainer. Being a maintainer
entails making sure all tests run and pass on that implementation. When
something breaks on your implementation, you will be responsible for providing
patches in a timely fashion. If critical issues for a particular implementation
exist at the time of a major release, support for that Ruby version may be
dropped.

Credits
-------

This is a fork of the original [equalizer](https://github.com/dkubb/equalizer).

* Dan Kubb ([dkubb](https://github.com/dkubb))
* Piotr Solnica ([solnic](https://github.com/solnic))
* Markus Schirp ([mbj](https://github.com/mbj))
* Erik Michaels-Ober ([sferik](https://github.com/sferik))

Contributing
-------------

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

Copyright
---------

Copyright &copy; 2009-2013 Dan Kubb. See LICENSE for details.
