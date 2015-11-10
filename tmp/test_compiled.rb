require 'wavefile'
require './src/stream'
require './src/effect'
require './src/freq_sum'
require './src/freq_wave'
require './src/wave_form'

include WaveFile

fade = Proc.new do |t, sound|
  pos = t/sound.frequency/sound.length
  if pos > 0.95
    [1-(pos-0.95)/0.05, 0].max*sound.sample_at(t)
  else
    [10*pos, 1].min*sound.sample_at(t)
  end
end

sine = FreqSum.new
sine.waves.push FreqWave.new(1, 0, 0.5, :sine)
sine = Effect.new sine, fade

triangle = FreqSum.new
triangle.waves.push FreqWave.new(1, 0, 0.05, :sine)
triangle.waves.push FreqWave.new(1, 0, 0.15, :triangle)
triangle = Effect.new triangle, fade

s = Stream.new({
  master: [{tempo: 100, volume: 75}],
  sine => [
    {frequency: 261.63, duration: 1},
    {frequency: 261.63, duration: 1},
    {frequency: 392.0, duration: 1},
    {frequency: 392.0, duration: 1},
    {frequency: 440.0, duration: 1},
    {frequency: 440.0, duration: 1},
    {frequency: 392.0, duration: 2},
    {frequency: 349.23, duration: 1},
    {frequency: 349.23, duration: 1},
    {frequency: 329.63, duration: 1},
    {frequency: 329.63, duration: 1},
    {frequency: 293.66, duration: 1},
    {frequency: 293.66, duration: 1},
    {frequency: 261.63, duration: 2},
  ],
  triangle => [
    {frequency: 261.63/4, duration: 1},
    {frequency: 261.63/2, duration: 1, chord: true},
    {frequency: 329.63/2, duration: 1, chord: true},
    {frequency: 392.0/4, duration: 1},
    {frequency: 261.63/4, duration: 1},
    {frequency: 261.63/2, duration: 1, chord: true},
    {frequency: 329.63/2, duration: 1, chord: true},
    {frequency: 392.0/4, duration: 1},
    {frequency: 261.63/4, duration: 1},
    {frequency: 261.63/2, duration: 1, chord: true},
    {frequency: 349.23/2, duration: 1, chord: true},
    {frequency: 440.0/4, duration: 1},
    {frequency: 261.63/4, duration: 1},
    {frequency: 261.63/2, duration: 1, chord: true},
    {frequency: 329.63/2, duration: 1, chord: true},
    {frequency: 392.0/4, duration: 1},
    {frequency: 261.63/4, duration: 1},
    {frequency: 261.63/2, duration: 1, chord: true},
    {frequency: 349.23/2, duration: 1, chord: true},
    {frequency: 440.0/4, duration: 1},
    {frequency: 261.63/4, duration: 1},
    {frequency: 261.63/2, duration: 1, chord: true},
    {frequency: 329.63/2, duration: 1, chord: true},
    {frequency: 392.0/4, duration: 1},
    {frequency: 293.66/4, duration: 1},
    {frequency: 293.66/2, duration: 1, chord: true},
    {frequency: 392.0/2, duration: 1, chord: true},
    {frequency: 493.88/4, duration: 1},
    {frequency: 261.63/4, duration: 1},
    {frequency: 261.63/2, duration: 1, chord: true},
    {frequency: 329.63/2, duration: 1, chord: true},
    {frequency: 392.0/4, duration: 1}
  ]
})

samps = s.samples
buffer = Buffer.new samps, Format.new(:mono, :float, 44100)
Writer.new 'test_comp.wav', Format.new(:mono, :pcm_16, 44100) do |writer|
  writer.write buffer
end
