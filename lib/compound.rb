##
# container representing the combination (sum) of two or more Sounds
#
# +author+ dustin walde
class Compound

  include Sound

  ##
  # Array<Sound>
  attr_reader :sounds

  ##
  # creates new Compound
  #
  # ===== params
  # [Array<Sound>, Sound+] if Array is passed, combines all Sounds in the array.
  # if 2 or more Sounds are passed, combines those
  #
  # ===== return
  # Compound newly created
  def initialize *sounds
    case sounds.length
    when 0
      raise "cannot create with no sounds"
    when 1
      @sounds = sounds[0]
    else
      @sounds = sounds
    end
  end

  ##
  # samples by taking the sum of every sound sampled at t
  def sample_at t
    #@sounds.map{|s| s.sample t}.reduce :+
    samples = @sounds.map{|s| s.sample t}
    ret = 0.0
    samples.each{|s| ret = s + ret }
    ret
  end

  def + rhs
    if rhs.class <= Compound
      Compound.new @sounds + rhs.sounds
    else
      Compound.new @sounds + [rhs]
    end
  end

  alias sound_set_values set_values
  def set_values args
    sound_set_values args
    @sounds.each { |sound| sound.set_values args }
  end

end
