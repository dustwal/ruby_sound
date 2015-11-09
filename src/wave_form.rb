include Math
module WaveForm

  TYPES = [:sawtooth, :sine, :square, :triangle]

  def self.wave sym, angle
    case sym
    when :triangle
      triangle angle
    when :sawtooth
      sawtooth angle
    when :square
      square angle
    else
      sin angle
    end
  end

  def self.noise
    rand * 2 - 1
  end

  def self.triangle langle
    if angle(langle) < PI/2
      2*angle(langle)/PI
    elsif angle(langle) < 3*PI/2
      2 - 2*angle(langle)/PI
    else
      2*angle(langle)/PI - 4
    end
  end

  def self.sawtooth langle
    angle(langle)/2 - 1
  end

  def self.square langle
    angle(langle) < PI ?
      1 :
      -1
  end

  def self.angle langle
    langle % (2*PI)
  end

end
