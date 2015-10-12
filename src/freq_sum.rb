class FreqSum

  attr_reader :waves
  attr_accessor :sample_rate

  def initialize sample_rate=44100
    @waves = []
    @sample_rate = sample_rate
  end

  def sample n
    waves.map{|w| w.sample n}.sum
  end

  def sample_at t
    waves.map{|w| w.sample_at t}.sum
  end

end
