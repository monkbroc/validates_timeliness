require 'date'
require 'parsedate'
require 'benchmark'
require 'rubygems'
require 'active_support'
require 'active_record'
require 'action_controller'

$: << 'lib'
require 'lib/validates_timeliness'

n = 10000
Benchmark.bm do |x|
  x.report('timeliness') { 
    n.times do
      ActiveRecord::Base.timeliness_date_time_parse("2000-01-04 12:12:12", :datetime)
    end 
  }
  
  x.report('date/time') { 
    n.times do
      "2000-01-04 12:12:12" =~ /\A(\d{4})-(\d{2})-(\d{2}) (\d{2})[\. :](\d{2})([\. :](\d{2}))?\Z/
      arr = [$1, $2, $3, $3, $5, $6].map {|i| i.to_i }
      Date.new(*arr[0..2])
      Time.mktime(*arr)
    end
  }
  
  x.report('parsedate') { 
    n.times do
      arr = ParseDate.parsedate("2000-01-04 12:12:12")
      Date.new(*arr[0..2])
      Time.mktime(*arr)
    end 
  }
  
  x.report('strptime') { 
    n.times do
      DateTime.strptime("2000-01-04 12:12:12", '%Y-%m-%d %H:%M:%s')
    end 
  }
end

