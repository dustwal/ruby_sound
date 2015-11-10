module SoundFactory

  def self.create_sound *args
    case args.length
    when 0
      Sound::REST
    when 1
      Sound.load_file args[0]
    when 2
      Compound.new args[0], args[1]
    else
      raise "too many arguments (#{args.length}) for 0..2"
    end
  end

end
