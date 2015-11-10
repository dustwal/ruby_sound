require './lib/wave_form'

class FreqWave

  attr_accessor :frequency, :phase, :amplitude, :wave_form

  def initialize freq, phase, amp, wave
    @frequency    = freq
    @phase        = phase
    @amplitude    = amp
    @wave_form    = wave
  end

  def sample n, sample_rate=44100
    sample_at Float(n)/sample_rate
  end

  def sample_at t
    amplitude * WaveForm.wave(@wave_form, phase + t * frequency * 2 * Math::PI)
  end

end
