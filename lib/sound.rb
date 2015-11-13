module Sound

  def self.create_sound *args, &block
    case args.length
    when 0
      Rest.new
    when 1
      if block
        Effect.new args[0], &block
      else
        case args[0].split(".").last
        when "freq"
          FreqFile.load args[0]
        when "wav"
          WavSampler.new args[0]
        else
          raise "invalid filetype"
        end
        BaseSound.new args[0]
      end
    when 2
      Compound.new args[0], args[1]
    else
      raise "too many arguments (#{args.length}) for 0..2"
    end
  end

  def sample t
    Sample.new sample_at t
  end

  def sample_at t
    0
  end

  def sample_sound t
    if channels == 2
      samples = sample(t*frequency)
      left = [1, 2-2*pan].min
      right = [1, 2*pan].min
      if samples.length >= 2
        samples[0] *= volume*left
        samples[1] *= volume*right
        samples
      else
        samp = Sample.new [volume*samples*left, volume*samples*right]
        samp
      end
    else
      Sample.new(sample(t*frequency).to_f*volume)
    end
  end

  def samples
    if @samples[@values]
      @samples[@values]
    else
      arr = Array.new(Integer((length*sample_rate).round))
      arr.length.times do |i|
        arr[i] = sample_sound Float(i)/sample_rate
      end
      arr
    end
  end

  def set_values args
    if @values
      @values = @values.merge args
    else
      @values = args
    end
    [:pitch_set, :key, :type, :start, :sound, :chord].each do |k|
      @values.delete k
    end
    if @sound
      @sound.set_values @values
    end
  end

  def + rhs
    Compound.new self, rhs
  end

  def [] key
    sample_at key
  end

  ## Play Values
  def duration
    @values[:duration] || 0
  end

  def frequency
    @values[:frequency] || 1
  end

  def tempo
    @values[:tempo] || Stream::DEFAULT_VALUES[:tempo]
  end

  def full_length
    duration*60.0/tempo
  end

  def length_t
    duration*quantization*60.0/tempo
  end
  alias :length :length_t

  def quantization
    (@values[:quant] || Stream::DEFAULT_VALUES[:quant]) / 100.0
  end
  alias :quant :quantization

  def volume
    (@values[:volume] || Stream::DEFAULT_VALUES[:volume]) / 100.0
  end
  alias :vol :volume

  def panning
    (@values[:pan] || Stream::DEFAULT_VALUES[:pan]) / 100.0
  end
  alias :pan :panning

  def sample_rate
    @values[:sample_rate] || 44100
  end

  def channels
    @values[:channels] || Stream::DEFAULT_VALUES[:channels]
  end

  def save
    @samples = {} unless @samples
    @samples[@values.merge({})] = samples unless @samples[@values]
  end

end
