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

:<>:sound_test:<>:

:master: | (volume 30)
sound1:  | o5 c2 d4 e | f  g a  b |<c2 >b4 a | g  f e  d | c1      |~1  ||
sound2:  | o4 c2 c2   | d4 e f  g | a b<c2   |>b4 a g  f | e d c2  |~1  ||
sound3:  | o2 c1      | c2   d4 e | f g a  b |<c2  >b4 a | g f e d | c1 ||
