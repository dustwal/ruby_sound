bass = FreqSum[[1,0,0.75,:sine],[1,0,0.25,:triangle]] -> (sine_pan(2.0, 0.5)) -> (binaural_beats(3.0)) -> (inverse_power_fade(4))
mid = FreqSum[[1,0,0.5,:triangle],[1,0,0.5,:sine]] -> (power_fade(4))
high = FreqSum[[1,0,1,:sine]] -> (power_fade(3))

:<>: comp_01_20151112 :<>:

:master:  (volume 30) (tempo 65)
high:     o4
mid:      o3 (volume 20)
bass:     o2 (volume 50)(quant 100)

high: | r2 e4. c8 |>a2. a8<c | g4 g8 e c4 | a4 e2.             ||
mid:  | r2 g2     | e1       | e4 c  a e  | g1                 ||
bass: | c1        | c        |>a4<c2.     | (volume 30) c1/<c  ||
