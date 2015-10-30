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

  def set_values args
    if @values
      @values = @values.merge args
    else
      @values = args
    end
  end

  def + rhs
    Compound.new self, rhs
  end

  def [] key
    sample_at key
  end

end
