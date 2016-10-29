module GeoIP
  require 'geo_ip/version'
  require 'geo_ip/ip'
  def self.location(ip)
    IP.new(ip).location
  end
end
