require './score'

class Guitar

  include Sound

  def initialize weight=2, shape=nil
    @weight = weight
    @shape = shape
  end

  def set_values args
    super args
    set_base
  end

  def old_sample_at t
    wavelength = Float((sample_rate/frequency).round)
    i = (t/frequency*sample_rate+wavelength).round
    return nil if i < 0
    return @guitar[i] if @guitar[i]
    sum = 0
    @weight.times do |n|
      m = n
      m = n-1 if n == @weight-1
      sum += sample_at((i-2*wavelength+n)*frequency/sample_rate)*1.0/(2**(m+1))
    end
    @guitar[i] = sum
  end

  def hard_sample_at t
    i = (t/frequency*sample_rate+@wavelength_s).round
    return nil if i < 0
    return @guitar[i] if @guitar[i]
    sum = 0
    @weight.times do |n|
      sum += sample_at((i-2*@wavelength_s+n)*frequency/sample_rate)*1.0/@weight
    end
    @guitar[i] = sum
  end

  def sample_at t
    i = (t/frequency*sample_rate+@wavelength_s).round
    return nil if i < 0
    return @guitar[i] if @guitar[i]
    samp1 = sample_at (i-2*@wavelength_s)*frequency/sample_rate
    samp2 = sample_at (i-2*@wavelength_s+1)*frequency/sample_rate
    @guitar[i] = [1.0,[-1.0,((samp2-samp1)+samp1)/2.0].max].min
  end

  private

  def set_base
    @wavelength_s = Integer((sample_rate/frequency).round)
    if @shape
      set_shape
    else
      set_rand
    end
  end

  def set_shape
    @guitar = Array.new length_s+@wavelength_s
    @wavelength_s.times do |s|
      @guitar[s] = WaveForm.wave @shape, 2*Math::PI*Float(s)/@wavelength_s
    end
  end

  def set_rand
    @guitar = Array.new length_s+@wavelength_s
    @wavelength_s.times do |s|
      @guitar[s] = WaveForm.noise
    end
  end

end
