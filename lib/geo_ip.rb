module GeoIP
  require 'geo_ip/version'
  require 'geo_ip/ip'
  require 'geo_ip/database'
  def self.location(ip)
    IP.new(ip).location
  end
end
