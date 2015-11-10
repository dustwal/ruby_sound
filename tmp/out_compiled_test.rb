require './score'

include WaveFile

__streams = []
fade = Effect.define do |t, sound|
  pos = t/sound.frequency/sound.length
  if pos > 0.95
    [1-(pos-0.95)/0.05, 0].max*sound.sample_at(t)
  else
    [10*pos, 1].min*sound.sample_at(t)
  end
end

$sine = Effect.new(FreqSum[[1, 0, 0.5, :sine]], fade)

$triangle = Effect.new(FreqSum[[1, 0, 0.05, :sawtooth], [1, 0, 0.15, :triangle]], fade)

def begin_end()
  __length = 16.0
  __streams = []
  __streams.push Stream.new({
  $sine => [
    {type: :sound, frequency: :c},
    {type: :sound, frequency: :c},
    {type: :sound, frequency: :g},
    {type: :sound, frequency: :g},
    {type: :sound, frequency: :a},
    {type: :sound, frequency: :a},
    {type: :sound, duration: 2.0, frequency: :g},
    {type: :sound, duration: 1.0, frequency: :f},
    {type: :sound, frequency: :f},
    {type: :sound, frequency: :e},
    {type: :sound, frequency: :e},
    {type: :sound, frequency: :d},
    {type: :sound, frequency: :d},
    {type: :sound, duration: 2.0, frequency: :c}
  ],
  $triangle => [
    {type: :special, name: :o, value: 2},
    {type: :sound, frequency: :c},
    {type: :sound, frequency: :g, chord: true},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c, chord: true},
    {type: :sound, frequency: :e},
    {type: :operator, value: :>},
    {type: :sound, frequency: :c},
    {type: :sound, frequency: :g, chord: true},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c, chord: true},
    {type: :sound, frequency: :e},
    {type: :operator, value: :>},
    {type: :sound, frequency: :c},
    {type: :sound, frequency: :a, chord: true},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c, chord: true},
    {type: :sound, frequency: :f},
    {type: :operator, value: :>},
    {type: :sound, frequency: :c},
    {type: :sound, frequency: :g, chord: true},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c, chord: true},
    {type: :sound, frequency: :e},
    {type: :operator, value: :>},
    {type: :sound, frequency: :c},
    {type: :sound, frequency: :a, chord: true},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c, chord: true},
    {type: :sound, frequency: :f},
    {type: :operator, value: :>},
    {type: :sound, frequency: :c},
    {type: :sound, frequency: :g, chord: true},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c, chord: true},
    {type: :sound, frequency: :e},
    {type: :operator, value: :>},
    {type: :sound, frequency: :d},
    {type: :sound, frequency: :b, chord: true},
    {type: :operator, value: :<},
    {type: :sound, frequency: :d, chord: true},
    {type: :sound, frequency: :g},
    {type: :operator, value: :>},
    {type: :sound, frequency: :c},
    {type: :sound, frequency: :g, chord: true},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c, chord: true},
    {type: :sound, frequency: :e}
  ]
}, 16.0)

  __streams
end

def middle()
  __length = 8.0
  __streams = []
__streams.push Stream.new({
  $sine => [
    {type: :sound, frequency: :g},
    {type: :sound, frequency: :g},
    {type: :sound, frequency: :f},
    {type: :sound, frequency: :f},
    {type: :sound, frequency: :e},
    {type: :sound, frequency: :e},
    {type: :sound, duration: 2.0, frequency: :d}
  ],
  $triangle => [
    {type: :special, name: :o, value: 2},
    {type: :sound, frequency: :c},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c, chord: true},
    {type: :sound, frequency: :e, chord: true},
    {type: :sound, frequency: :g},
    {type: :operator, value: :>},
    {type: :sound, frequency: :c},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c, chord: true},
    {type: :sound, frequency: :f, chord: true},
    {type: :sound, frequency: :a},
    {type: :operator, value: :>},
    {type: :sound, frequency: :c},
    {type: :operator, value: :<},
    {type: :sound, frequency: :c, chord: true},
    {type: :sound, frequency: :e, chord: true},
    {type: :sound, frequency: :g},
    {type: :operator, value: :>},
    {type: :sound, frequency: :d},
    {type: :operator, value: :<},
    {type: :sound, frequency: :d, chord: true},
    {type: :sound, frequency: :g, chord: true},
    {type: :sound, frequency: :b}
  ]
}, 8.0)

  __streams
end

score_title = "Twinkle Twinkle, Little Star"


__streams.push Stream.new({
  :master => [
    {tempo: 100},
    {volume: 25},
    {type: :stream, streams: begin_end()},
    {type: :stream, streams: middle()},
    {type: :stream, streams: middle()},
    {type: :stream, streams: begin_end()}
  ],
  $sine => [
    {type: :sound, duration: 2.0, frequency: :c},
    {type: :sound, duration: 1.0, frequency: :d},
    {type: :sound, frequency: :e},
    {type: :sound, frequency: :f},
    {type: :sound, frequency: :g},
    {type: :sound, frequency: :a},
    {type: :sound, frequency: :b},
    {type: :sound, duration: 2.0, frequency: :c},
    {type: :sound, duration: 1.0, frequency: :b},
    {type: :sound, frequency: :a},
    {type: :sound, frequency: :g},
    {type: :sound, frequency: :f},
    {type: :sound, frequency: :e},
    {type: :sound, frequency: :d},
    {type: :sound, duration: 4.0, frequency: :c}
  ]
})
samps = []
__streams.each {|s| samps += s.samples}
buffer = Buffer.new samps, Format.new(:mono, :float, 44100)
Writer.new score_title.gsub(/[^a-zA-Z\-\_]/, "")+".wav", Format.new(:mono, :pcm_16, 44100) do |writer|
  writer.write buffer
end