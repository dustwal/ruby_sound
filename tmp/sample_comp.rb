# default time signature 4/4
# default tempo 100

loud = Effect.by_time { |t, sound| 2*sound[t] }
fade = Effect.by_sample do |s, sound|
  if s > sound.length - 10000
    sound[s]*(1-0.0001*(s-sound.length-1000))
  else
    sound[s]
  end
end
fp = 'sample_file.(wav|freq|snd)'
ssound = Sound.new loud, (Sound.new fade, Sound.new(fp))

def b1 arg
  stream = Stream.new 1
  stream.push [[{sound: sound, durration: 4, frequency: Frequency.octave(3)*Frequency::MAP[:c], effects: []}, ..., ]]
  stream.push [[{...}]] if arg == 0
  stream
end

# do smaller durations first (to priorotize Mods (or just chech for mods)
stream = Stream.new 3
stream.push [[r1, Mod.new {tempo: 120}], [

  b1(0), {sound: ssound, ...}, ..., b1(1)

],[...]]

sqnce = Sequence.new 3

