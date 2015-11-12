class Sample


  def initialize sample, num_channels=nil
    if sample.is_a? Array
      @sample = sample
    elsif sample.is_a? Sample
      @sample = sample.to_a
      num_channels = @sample.length unless num_channels
    else
      @sample = [sample]
      num_channels = 1 unless num_channels
    end
    self.channels = channels
  end

  def channels= n
    while @sample.length > n
      @sample.pop
    end
    while @sample.length < n
      @sample.push 0.0
    end
    n
  end

  def channels
    @sample.length
  end
  alias :length :channels

  def [] index
    @sample[index]
  end

  def []= index, value
    @sample[index] = value
  end

  def + rhs
    if rhs.is_a? Array or rhs.is_a? Sample
      if @sample.length == 1
        @sample[0] + rhs[0]
      else
        ret = Array.new @sample.length
        @sample.length.times { |i| ret[i] = @sample[i]+rhs[i] }
        ret
      end
    else
      if @sample.length == 1
        @sample[0] + rhs
      else
        @sample.map { |s| s + rhs }
      end
    end
  end

  def * rhs
    if rhs.is_a? Array or rhs.is_a? Sample
      if @sample.length == 1
        @sample[0] * rhs[0]
      else
        ret = Array.new @sample.length
        @sample.length.times { |i| ret[i] = @sample[i]+rhs[i] }
        ret
      end
    else
      if @sample.length == 1
        @sample[0] * rhs
      else
        @sample.map { |s| s*rhs }
      end
    end
  end

  def to_a
    @sample
  end

  def to_final
    @sample.length == 1 ? @sample[0] : @sample
  end

  def to_f
    @sample.inject(0.0) {|sum,n| sum + n} / @sample.length
  end

  def coerce lhs
    [self, lhs]
  end

end