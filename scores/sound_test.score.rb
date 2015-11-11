linear_fade = Effect.define do |t, sound|
  pos = t/sound.frequency/sound.length
  (1.0-pos)*sound.sample_at(t)
end

quadratic_fade = Effect.define do |t, sound|
  pos = t/sound.frequency/sound.length
  ((1.0-pos)**2)*sound.sample_at(t)
end

inv_quadratic_fade = Effect.define do |t, sound|
  pos = t/sound.frequency/sound.length
  (1.0-(pos**2))*sound.sample_at(t)
end

sound1 = FreqSum[[1,0,1,:sine]] -> linear_fade
sound2 = FreqSum[[1,0,1,:sine]] -> quadratic_fade
sound3 = FreqSum[[1,0,1,:sine]] -> inv_quadratic_fade

tonedef scale [16:] (sound)
  ::=
    sound: | c2 d4 e | f g a b |<c2>b4 a | g f e d |
    =::
fin


:<>:sound_test:<>:

:master: | (volume 30)
sound1:  | o5 scale(sound1) | c1  |~1                      ||
sound2:  | o4 r2 scale(sound2) c2 |~1                      ||
sound3:  | o2 r1  | scale(sound3) | (c4 e g<c) -> quadratic_fade ||
