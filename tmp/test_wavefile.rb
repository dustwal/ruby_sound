require 'wavefile'

include WaveFile
a_in = []
a_out = []
Writer.new "king_out.wav", Format.new(:mono, :pcm_8, 44100) do |writer|
  i = 0
  Reader.new("samples/king_love.wav").each_buffer 4096 do |buffer|
    if i == 0
      100.times{|i| a_in.push buffer.samples[i]}
    end
    writer.write(buffer)
    i += 1
  end

end
i = 0
Reader.new("king_out.wav").each_buffer 4096 do |buffer|
  if i == 0
    100.times{|i| a_out.push buffer.samples[i]}
  end
  i += 1
end

100.times do |i|
  puts "#{a_in[i]} #{a_out[i]}"
end
