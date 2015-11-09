require 'wavefile'

include WaveFile

samples = Array.new 44000
44000.times do |i|
  samples[i] = (Math.sin i*440*2*Math::PI/44100.0)
end

buffer = Buffer.new samples, Format.new(:mono, :float, 44100)
Writer.new "sine_out.wav", Format.new(:stereo, :pcm_16, 44100) do |writer|
  writer.write buffer
end
