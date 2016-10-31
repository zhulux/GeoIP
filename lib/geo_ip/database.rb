require 'singleton'
module GeoIP
  DB_PATH = File.expand_path '../../data/ip.dat', __FILE__
  OFFSET_HEAD_LENGTH = 4
  class Database
    include Singleton

    attr_reader :index
    attr_reader :offset
    attr_reader :max_comp_length

    def initialize
      load_index
      super
    end

    def read(_offset, length)
      IO.read(DB_PATH, length, @offset + _offset - 1024).split("\t").map do |str|
        str.encode('UTF-8', 'UTF-8')
      end
    end

    private

    def load_index
      File.open(GeoIP::DB_PATH) do |file|
        @offset = file.read(OFFSET_HEAD_LENGTH).unpack("Nlen")[0]
        @index = file.read(@offset - OFFSET_HEAD_LENGTH)
        @max_comp_length = @offset - 1024 - 4
      end
    end
  end
end
