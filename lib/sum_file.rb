# module defines methods for reading and writing .freq files
#
# @author dustin walde
module SumFile

  # saves a freq_sum to a file
  # @param freq_sum [WaveSum] freq sum to save
  # @param filename [String] file path to save to
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

  # loads WaveSum from a .freq file
  # @param filename [String] the filepath of the .freq file
  # @return [WaveSum] object representation of the .freq file
  def self.load filename
    file = File.new filename
    freq_sum = WaveSum.new
    curr_type = nil
    file.each do |line|
      puts line
      if WaveForm::TYPES.include? line.strip.to_sym
        curr_type = line.to_sym
      elsif line.match "noise"
        freq_sum.noise = Float line.split(" ")[1]
      else
        freq, phase, amp = line.split(" ").map{|word| Float word}
        freq_sum.waves.push Wave.new(freq, phase, amp, line.strip.to_sym)
      end
    end
    file.close
    freq_sum
  end

end
