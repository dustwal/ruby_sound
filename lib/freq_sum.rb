require './lib/sound'

class FreqSum

  include Sound

  attr_reader :waves
  attr_accessor :noise

  def initialize
    @waves = []
    @noise = 0
  end

  def sample_at t, freq=1
    waves.map{|w| w.sample_at t*freq}.reduce(:+) + @noise*WaveForm.noise
  end

  def self.[] *arr
    fs = FreqSum.new
    arr.each do |attrs|
      if attrs.length == 4
        fs.waves.push FreqWave.new(attrs[0], attrs[1], attrs[2], attrs[3])
      else
        @noise = attrs[0]
      end
    end
    fs
  end

end
