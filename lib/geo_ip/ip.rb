require 'ipaddr'
require 'pry'
module GeoIP
  DB_PATH = File.expand_path '../../data/ip.dat', __FILE__
  OFFSET_HEAD_LENGTH = 4
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

    def index(file, offset, length=1)
      file.seek(OFFSET_HEAD_LENGTH + offset)
      file.read(length)
    end

    def location

      File.open(DB_PATH,'rb') do |file|
        offset = file.read(OFFSET_HEAD_LENGTH).unpack('Nlen')[0]
        max_comp_length = offset - 1024 - 4
        tmp_offset = numbers[0] * 4
        start = index(file, tmp_offset, 4).unpack('V')[0] * 8 + 1024
        index_offset = nil
        index_length = nil
        while start < max_comp_length
          if index(file, start, 4) >= packed_ip
            index_offset = "#{index(file, start + 4, 3)}\x0".unpack("V")[0]
            index_length = index(file, start + 7).unpack("C")[0]
            break
          end
          start += 8
        end
        @result = index(file, offset + index_offset - 1024 - 4, index_length).split("\t").map do |str|
          str.encode("UTF-8", "UTF-8")
        end
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
