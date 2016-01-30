class WavSampler

  include Sound
  include WaveFile

  def initialize filepath, base_freq=440.0
    @wav_samples = []
    @wav_base = base_freq # modify based on file sample rate, seems to just map samples when changing format instead of expanding
    format = Format.new :stereo, :float, 44100
    Reader.new(filepath, format).each_buffer 8192 do |buffer|
      @wav_sample_rate = buffer.sample_rate
      @wav_samples += buffer.samples
    end
  end

  def sample_at t
    index = Integer(t*@wav_sample_rate/@wav_base)
    @wav_samples[index] || 0
  end

end
