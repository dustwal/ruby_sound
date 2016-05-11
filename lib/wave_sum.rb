require './lib/sound'

class WaveSum

  include Sound

  attr_reader :waves
  attr_accessor :noise

  def initialize
    @waves = []
    @noise = 0
  end

  def sample_at t, freq=1
    waves.map{|w| w.sample_at t*freq}.reduce(0, :+) + @noise*WaveForm.noise
  end

  def self.[] *arr
    if arr.length == 1 and arr[0].is_a? Symbol
      fs = WaveSum.new
      fs.waves.push Wave.new(1,0,1,arr[0])
      return fs
    end
    fs = WaveSum.new
    arr.each do |attrs|
      if attrs.length == 4
        fs.waves.push Wave.new(attrs[0], attrs[1], attrs[2], attrs[3])
      else
        @noise = attrs[0]
      end
    end
    fs
  end

end
