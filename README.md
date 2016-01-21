[![Gem Version](https://badge.fury.io/rb/ice_cube_cron.svg)](https://badge.fury.io/rb/ice_cube_cron) [![Build Status](https://travis-ci.org/mattnichols/ice_cube_cron.svg?branch=master)](https://travis-ci.org/mattnichols/ice_cube_cron) [![Code Climate](https://codeclimate.com/github/mattnichols/ice_cube_cron/badges/gpa.svg)](https://codeclimate.com/github/mattnichols/ice_cube_cron) [![Test Coverage](https://codeclimate.com/github/mattnichols/ice_cube_cron/badges/coverage.svg)](https://codeclimate.com/github/mattnichols/ice_cube_cron/coverage)

# ice_cube_cron

Adds new methods to ice_cube to create schedules using standard cron expressions.

## description

**[ice_cube](https://github.com/seejohnrun/ice_cube)** is a sold library for projecting and querying recurrence rules. **[Cron](https://en.wikipedia.org/wiki/Cron)** is _the_ standard for expressing recurrence rules. This gem will allow you to generate ice_cube schedules using standard cron expressions [explained here](https://en.wikipedia.org/wiki/Cron). This includes range expressions, series expressions, "last" day of month, Nth weekday of month, etc.

## installation

    gem install ice_cube_cron

or add to Gemfile

    gem "ice_cube_cron"

## example

```
 # * * * * * *  command to execute
 # │ │ │ │ │ │
 # │ │ │ │ │ │
 # │ │ │ │ │ └───── year (optional) (1970–2099)
 # │ │ │ │ └───── day of week (0 - 6)
 # │ │ │ └────────── month (1 - 12)
 # │ │ └─────────────── day of month (1 - 31)
 # │ └──────────────────── hour (0 - 23)
 # └───────────────────────── min (0 - 59)
```

*[chart source](https://en.wikipedia.org/wiki/Cron)*


Cron expression can be specified using a hash or a string in the format:

```ruby
require 'ice_cube_cron'

# using cron expression string
schedule = ::IceCube::Schedule.from_cron(::Date.current, "0 0 * * 5")

# using hash
schedule = ::IceCube::Schedule.from_cron(::Date.new(2015, 1, 5), :hour => 0, :minute => 0, :day_of_month => 5)

schedule.occurrences_between(::Date.new(2015, 3, 5), ::Date.new(2015, 6, 5))
# => [2015-03-05 00:00:00 UTC, 2015-04-05 00:00:00 UTC, 2015-05-05 00:00:00 UTC, 2015-06-05 00:00:00 UTC]
```

## recurrence rule examples

* *These are __Date Only__ - hour and minute are set to zero*

|desc|interval|year|month|day_of_month|day_of_week|
|----|-------:|---:|----:|--:|------:|
|1st of every month||||1||
|1st and 15th of every month||||1,15||
|every monday|||||1|
|1st tuesday of every month|||||2#1|
|ever other friday|2||||5|
|every 6 months on the 5th|6|||5||
|last friday of every month|||||5L|
|last day every month||||L||

## notes
- Does not validate cron expressions

## todo
- Add support for W special character
- Change hash param `day` to `day_of_month`
- Improve expression validation
