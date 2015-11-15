require './score'

class Guitar

  include Sound

  def initialize weight=2
    @weight = weight
  end

  def set_values args
    super args
    set_base
  end

  def sample_at t
    wavelength = Float((sample_rate/frequency).round)
    i = (t/frequency*sample_rate+wavelength).round
    return nil if i < 0
    return @guitar[i] if @guitar[i]
    sum = 0
    @weight.times do |n|
      n = n-1 if n == @weight-1
      sum += sample_at((i-2*wavelength+n)*frequency/sample_rate)*1.0/(2**(n+1))
    end
    @guitar[i] = sum
  end

  private

  def set_base
    base_len = Integer((sample_rate/frequency).round)
    @guitar = Array.new length_s+base_len
    Integer((sample_rate/frequency).round).times do |s|
      @guitar[s] = Random.rand*2-1
    end
  end

end
