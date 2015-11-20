##
# defines basic functionality for sampling sounds and setting values
# such as duration frequency to describe the state of the sound to sample
#
# +author+ dustin walde
module Sound

  ##
  # create sound from a filepath.
  #
  # ===== params
  # [String +filename+] .wav or .sum file to load
  #
  # ===== return
  # (WaveSum, WavSampler) newly loaded Sound
  def self.load_file filename
    case args[0].split(".").last
    when "sum"
      SumFile.load args[0]
    when "wav"
      WavSampler.new args[0]
    else
      raise "invalid filetype"
    end
  end

  ##
  # take a sample at given time t
  #
  # ===== params
  # [Numeric +t+] time in seconds to take sample at
  #
  # ===== return
  # Sample of sound at time t
  def sample t
    Sample.new sample_at t
  end

  ##
  # similar to #sample but with no weaker guarantee of return type
  #
  # ===== params
  # [Numeric +t+] time (seconds) to take sample
  #
  # ===== return
  # (Numeric, Array<Numeric>, Sample) sample compatible value
  def sample_at t
    0
  end

  ##
  # sample sound at time t taking into account the values of the sound
  #
  # ===== params
  # [Numeric +t+] time in seconds to sample at
  #
  # ===== return
  # Sample computed at time t
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

  ##
  # samples the entire sound
  #
  # ===== return
  # Array<Sample> all samples of the sound
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

  ##
  # set the values of this sound to ready sampling
  #
  # ===== params
  # [Hash +args+] values to set
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

  ##
  # creates a compound sound from this sound and the rhs
  #
  # ===== param
  # [Sound +rhs+] sound to create Compound with
  def + rhs
    Compound.new self, rhs
  end

  ##
  # shorthand for sampling a sound
  #
  # ===== params
  # [Numeric +t+] the time to sample at
  #
  # ===== return
  # Sample at time t
  def [] t
    sample t
  end

  ## Play Values

  ##
  # ===== return
  # Numeric of the length in beats of the sound
  def duration
    @values[:duration] || 0
  end

  ##
  # ===== return
  # Numeric of the frequency of the sound
  def frequency
    @values[:frequency] || 1
  end

  ##
  # ===== return
  # Numeric the tempo of the sound
  def tempo
    @values[:tempo] || Stream::DEFAULT_VALUES[:tempo]
  end

  ##
  # ===== return
  # Float of the full amount of time the sound takes up in the score
  def full_length
    duration*60.0/tempo
  end

  ##
  # ===== return
  # Integer of the length in samples of audible
  # sampled sound based on current values
  def length_s
    Integer (length_t*sample_rate).round
  end

  ##
  # ===== return
  # Float of the length in seconds of the audible
  # portion of sound based on current values
  def length_t
    duration*quantization*60.0/tempo
  end
  alias :length :length_t

  ##
  # ===== return
  # Float of the quantization (length of note) of the sound
  def quantization
    (@values[:quant] || Stream::DEFAULT_VALUES[:quant]) / 100.0
  end
  alias :quant :quantization

  ##
  # ===== return
  # Float of the volume of the sound
  def volume
    (@values[:volume] || Stream::DEFAULT_VALUES[:volume]) / 100.0
  end
  alias :vol :volume

  ##
  # ===== return
  # Float of the panning of the sound
  def panning
    (@values[:pan] || Stream::DEFAULT_VALUES[:pan]) / 100.0
  end
  alias :pan :panning

  ##
  # ===== return
  # Numeric of the sample rate for the sound
  def sample_rate
    @values[:sample_rate] || 44100
  end

  ##
  # ===== return
  # Integer of the number of channels for the sound to sample in
  def channels
    @values[:channels] || Stream::DEFAULT_VALUES[:channels]
  end

  ##
  # take and save a set of samples based on the currend values of the sound
  def save
    @samples = {} unless @samples
    @samples[@values.merge({})] = samples unless @samples[@values]
  end

end
