linear_fade = power_fade 1
quadratic_fade = power_fade 2
inv_quadratic_fade = inverse_power_fade 2

lr = Effect.define do |t, sound|
  realt = t/sound.frequency
  inner_pan = Math.sin(4*Math::PI*realt)/2.0+0.5
  sample = sound.sample(t).to_f
  [inner_pan*sample, (1-inner_pan)*sample]
end

sound1 = FreqSum[[1,0,1,:sine]] -> linear_fade
sound2 = FreqSum[[1,0,1,:sine]] -> power_fade(2)
sound3 = FreqSum[[1,0,1,:sine]] -> inv_quadratic_fade -> lr

tonedef scale (sound)
  ::=
    sound: | c\gM2/h c+4 ddim | e- e f f+ | {:g} a- a b- | b <{:c}{2.0}>b{1.0} a+ | a g+ g g- | f e d+ d | d-
  =::
fin

somestream = ::= sound1: scale(sound1) =::

:<>:sound_test:<>:

:master: | (volume 25)
sound1:  |             o5 [somestream] | c1 |~1  |~1                              ||
sound2:  |             o4 r1~4  |scale(sound2) | c1 |~1                           ||
sound3:  | (volume 30) o2 r1  |~1~2 | scale(sound3) | (c4 e g<c) -> power_fade(2) ||
