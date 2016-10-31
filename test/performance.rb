require 'ruby-prof'
require 'geo_ip'
[RubyProf::WALL_TIME, RubyProf::MEMORY, RubyProf::ALLOCATIONS, RubyProf::CPU_TIME].each do |measure|
  RubyProf.measure_mode = measure
  RubyProf.start
  2000.times do
    GeoIP.location(Array.new(4) { rand(256) }.join('.'))
  end
  result = RubyProf.stop
  printer = RubyProf::FlatPrinter.new(result)
  printer.print(STDOUT, :min_percent => 2)
end
