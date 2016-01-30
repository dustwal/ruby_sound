include Math
module WaveForm

  TYPES = [:abscircle, :abssawtooth, :abssine, :abstriangle, :circle, :sawtooth, :sine, :square, :triangle]

  def self.wave sym, angle
    case sym
    when :abscircle
      2*(circle angle/2.0).abs-1
    when :abssawtooth
      2*(sawtooth angle).abs-1
    when :abssine
      2*(sin angle/2.0).abs-1
    when :abstriangle
      2*(triangle angle/2.0).abs-1
    when :circle
      circle angle
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

  def self.circle langle
    theta = angle langle
    if theta < PI
      (2/PI)*sqrt(((PI/2)**2)-((theta-PI/2)**2))
    else
      -(2/PI)*sqrt(((PI/2)**2)-((theta-3*PI/2)**2))
    end
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
    angle(langle)/PI - 1
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
