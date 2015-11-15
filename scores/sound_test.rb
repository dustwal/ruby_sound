require './score'

include WaveFile
include ARB::EFX

__master = { master: {
    sample_rate: (Float(ARGV[0]) || 44100.0)
  }
}

__streams = []
linear_fade = ARB::EFX.power_fade 1
quadratic_fade = ARB::EFX.power_fade 2
inv_quadratic_fade = ARB::EFX.inverse_power_fade 2

lr = Effect.define do |t, sound|
  realt = t/sound.frequency
  inner_pan = Math.sin(4*Math::PI*realt)/2.0+0.5
  sample = sound.sample(t).to_f
  [inner_pan*sample, (1-inner_pan)*sample]
end

sound1 = Effect.new(FreqSum[[1,0,1,:sine]], linear_fade)
sound2 = Effect.new(FreqSum[[1,0,1,:sine]], quadratic_fade)
sound3 = Effect.new(Effect.new(FreqSum[[1,0,1,:sine]], inv_quadratic_fade), lr)

def scale(sound)
  __length = 16.0
  __streams = []
  __streams.push Stream.new({
  sound => [
    {type: :sound, duration: 2.0, frequency: :c},
    {type: :sound, duration: 1.0, frequency: :d},
    {type: :sound, frequency: :e},
    {type: :sound, frequency: :f},
    {type: :sound, frequency: :g},
    {type: :sound, frequency: :a},
    {type: :sound, frequency: :b},
    {type: :operator, value: :<},
    {type: :sound, duration: 2.0, frequency: :c},
    {type: :operator, value: :>},
    {type: :sound, duration: 1.0, frequency: :b},
    {type: :sound, frequency: :a},
    {type: :sound, frequency: :g},
    {type: :sound, frequency: :f},
    {type: :sound, frequency: :e},
    {type: :sound, frequency: :d}
  ]
}, 16.0)

  __streams
end

score_title = "sound_test"


__streams.push Stream.new({
  :master => [
    {volume: 30}
  ],
  sound1 => [
    {type: :special, name: :o, value: 5},
    {type: :stream, streams: scale(sound1)},
    {type: :sound, duration: 12.0, frequency: :c}
  ],
  sound2 => [
    {type: :special, name: :o, value: 4},
    {type: :special, name: :r, value: 4.0},
    {type: :stream, streams: scale(sound2)},
    {type: :sound, duration: 8.0, frequency: :c}
  ],
  sound3 => [
    {volume: 50},
    {type: :special, name: :o, value: 2},
    {type: :special, name: :r, value: 8.0},
    {type: :stream, streams: scale(sound3)},
    {type: :stream, streams: [Stream.new({
  Effect.new(sound3, quadratic_fade) => [
    {type: :sound, duration: 1.0, frequency: :c},
    {type: :sound, frequency: :e},
    {type: :sound, frequency: :g},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c}
  ]
})
]}
  ]
})
samps = []
__streams.each do |stream|
  stream.set_values __master
  samps += stream.samples
end
channels = samps[0].is_a?(Array) ? samps[0].length : 1
buffer = Buffer.new samps, Format.new(channels, :float, __master[:master][:sample_rate])
Writer.new score_title.gsub(/[^a-zA-Z0-9\-\_]/, "")+".wav",
  Format.new(channels, :pcm_16, __master[:master][:sample_rate]) do |writer|
  writer.write buffer
end
