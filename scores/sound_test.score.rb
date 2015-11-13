linear_fade = ARB::EFX.power_fade 1
quadratic_fade = ARB::EFX.power_fade 2
inv_quadratic_fade = ARB::EFX.inverse_power_fade 2

lr = Effect.define do |t, sound|
  realt = t/sound.frequency
  inner_pan = Math.sin(4*Math::PI*realt)/2.0+0.5
  sample = sound.sample(t).to_f
  [inner_pan*sample, (1-inner_pan)*sample]
end

sound1 = FreqSum[[1,0,1,:sine]] -> linear_fade
sound2 = FreqSum[[1,0,1,:sine]] -> quadratic_fade
sound3 = FreqSum[[1,0,1,:sine]] -> inv_quadratic_fade -> lr

tonedef scale [16:] (sound)
  ::=
    sound: | c2 d4 e | f g a b |<c2>b4 a | g f e d |
    =::
fin

:<>:sound_test:<>:

:master: | (volume 30)
sound1:  |             o5 scale(sound1) | c1 |~1  |~1                            ||
sound2:  |             o4 r1  |scale(sound2) | c1 |~1                            ||
sound3:  | (volume 50) o2 r1  |~1 | scale(sound3) | (c4 e g<c) -> quadratic_fade ||
