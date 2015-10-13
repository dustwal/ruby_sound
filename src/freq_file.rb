module FreqFile

  def self.save freq_sum, filename
    file = File.new filename, "w"
    wave_map = {}
    WaveForm::TYPES.each do |t|
      wave_map[t] = []
    end
    freq_sum.waves.each do |w|
      wave_map[w.wave_form].push w
    end
    wave_map.each do |type, arr|
      file.write "#{type}\n"
      arr.each do |w|
        file.write "#{w.frequency} #{w.phase} #{w.amplitude}\n"
      end
    end
    file.write "noise #{freq_sum.noise}"
    file.close
  end

  def self.load filename
    file = File.new filename
    freq_sum = FreqSum.new
    curr_type = nil
    file.each do |line|
      puts line
      if WaveForm::TYPES.include? line.strip.to_sym
        curr_type = line.to_sym
      elsif line.match "noise"
        freq_sum.noise = Float line.split(" ")[1]
      else
        freq, phase, amp = line.split(" ").map{|word| Float word}
        freq_sum.waves.push FreqWave.new(freq, phase, amp, line.strip.to_sym)
      end
    end
    file.close
    freq_sum
  end

end
