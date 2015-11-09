require 'wavefile'

include WaveFile

i = 0
Reader.new("test_comp.wav").each_buffer 4096 do |buffer|
  if i == 0
    500.times{|i| puts 2*buffer.samples[i]/65536.0}
  end
  i += 1
end
