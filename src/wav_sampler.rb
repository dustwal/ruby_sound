class WavSampler

  include Sound
  include WaveFile

  def initialize filepath
    @samples = []
    Reader.new(filepath).each_buffer 8192 do |buffer|
      @sample_rate = buffer.sample_rate
      @samples += buffer.samples
    end
  end

  def sample_at t, freq
    samples[Integer t*@sample_rate]
  end

end
