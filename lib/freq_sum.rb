require './lib/sound'

class FreqSum

  include Sound

  attr_reader :waves
  attr_accessor :sample_rate, :noise

  def initialize sample_rate=44100
    @waves = []
    @noise = 0
    @sample_rate = sample_rate
  end

  def sample_at t, freq=1
    waves.map{|w| w.sample_at t*freq}.reduce(:+) + @noise*WaveForm.noise
  end

  def self.[] *arr
    fs = FreqSum.new
    arr.each do |attrs|
      fs.waves.push FreqWave.new(attrs[0], attrs[1], attrs[2], attrs[3])
    end
    fs
  end

end
