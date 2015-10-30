class FreqSum

  include Sound

  attr_reader :waves
  attr_accessor :sample_rate, :noise

  def initialize sample_rate=44100
    @waves = []
    @noise = 0
    @sample_rate = sample_rate
  end

  def sample_at t, freq
    waves.map{|w| w.sample_at t*freq}.reduce(:+) + @noise*WaveForm.noise
  end

end
