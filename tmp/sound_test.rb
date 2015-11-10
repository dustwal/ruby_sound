require 'wavefile'
require './sound_core'
include WaveFile

#Reader.new('king_love.wav').each_buffer 4096 do |buffer|
  #puts buffer.samples.length
#end

puts (WaveForm.wave :triangle, Math::PI/4)
puts (WaveForm.wave :sin, Math::PI/4)
puts (WaveForm.wave :square, Math::PI/4)
puts (WaveForm.wave :sawtooth, Math::PI/4)

fs = FreqSum.new
fs.waves.push FreqWave.new(1, 0, 0.5, :sine)
fs.waves.push FreqWave.new(2, 0, 0.5, :sine)
samples = []
44100.times {|i| samples.push(fs.sample_at i/44100.0, 440)}
fs.waves.each{|w| w.wave_form = :triangle}
44100.times {|i| samples.push(fs.sample_at i/44100.0, 440)}
fs.waves.each{|w| w.wave_form = :sawtooth}
44100.times {|i| samples.push(fs.sample_at i/44100.0, 220)}
fs.waves.each{|w| w.wave_form = :square}
44100.times {|i| samples.push(fs.sample_at i/44100.0, 220)}
buffer = Buffer.new samples, Format.new(:mono, :float, 44100)
Writer.new 'sample_sine.wav', Format.new(:mono, :pcm_16, 44100) do |writer|
  writer.write buffer
end
FreqFile.save fs, "fs.freq"
new_fs = FreqFile.load "fs.freq"

puts new_fs.waves.length