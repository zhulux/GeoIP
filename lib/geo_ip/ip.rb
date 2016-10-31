module GeoIP
  require 'ipaddr'
  require 'pry'
  class IP
    attr_reader :ip

    def initialize(ip_address)
      @ip = IPAddr.new(ip_address)
    end

    def numbers
      @numbers ||= ip.to_s.split('.').map(&:to_i)
    end

    def packed_ip
      @packed_ip ||= [ip.to_i].pack 'N'
    end


    def location
      tmp_offset = numbers[0] * 4
      start = Database.instance.index[tmp_offset..(tmp_offset+3)].unpack('V')[0] * 8 + 1024
      index_offset = nil
      index_length = nil
      while start < Database.instance.max_comp_length
        if Database.instance.index[start..(start+3)] >= packed_ip
          index_offset = "#{Database.instance.index[(start+4)..(start+6)]}\x0".unpack("V")[0]
          index_length = Database.instance.index[(start+7)].unpack("C")[0]
          break
        end
        start += 8
      end
      @result = Database.instance.read(index_offset, index_length).split("\t").map do |str|
        str.encode('UTF-8', 'UTF-8')
      end
      return nil unless @result
      {
        country: @result[0],
        province: @result[1],
        city: @result[2]
      }
    end
  end
end
