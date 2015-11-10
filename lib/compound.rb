class Compound

  include Sound
  attr_reader :sounds

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

  def sample_at t
    @sounds.map{|s| s[t]}.reduce :+
  end

  def + rhs
    if rhs.class <= Compound
      Compound.new @sounds + rhs.sounds
    else
      Compound.new @sounds + [rhs]
    end
  end

end
