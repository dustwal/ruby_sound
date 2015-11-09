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

  def sample_at t
    0
  end

  def sample t
    if channels == 2
      samples = sample_at frequency*t
      [volume*[1, 1-2*pan].min*samples[0],
       volume*[1, 2*pan].min*samples[1]]
    else
      volume * sample_at(frequency*t)
    end
  end

  def set_values args
    if @values
      @values = @values.merge args
    else
      @values = args
    end
    if @sound
      @sound.set_values args
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

end
