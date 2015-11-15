$bass = FreqSum[[1,0,0.7,:sine],[1,0,0.2,:triangle],[2,0,0.1,:sine]] ->
          (binaural_beats(3.0)) -> (inverse_power_fade(3))
$gtar = (Guitar.new 4) -> (power_fade(1))
$beat = FreqSum[[1,0,0.2,:sawtooth],[0.8]] -> (power_fade(5))
$melt = FreqSum[[1,0,0.25,:triangle],[1,0,0.65,:sine],[2,0,0.1,:sine]] -> (power_fade(2))
$harm = FreqSum[[1,0,1,:sine]] -> (inverse_power_fade(2))

tonedef beats_1 [:$beat] (n)
  (n-1).times do
    ::= >c4<c c8 c16 c =::
  end
  ::= >c4<c =::
fin


:<>:slow comp:<>:

:master:   | (tempo 80) (volume 20)
$melt:     | o4
$harm:     | o4 (volume 15)
$gtar:     | o4 (volume 15)
$bass:     | o2
$beat:     | o2 (volume 15)

$melt:  c4        | d  d  d    | d d d8 e16 f | a4. a4 f8  | e e e e e e | e16>c g4.~4 | g4   g g    |<e16 c>g4.~4 | g8 g g16 g g32 g g64 g g g
$harm:  r4        | f  f  f8 d | f4 f a       | e  e  e    | g2.         | g4 g  g     |<e16 c>g4.~4 | r2.         |
$gtar:  r8    d   | f4/a r. a8 | f4/a r. f8   | e4/a r. e8 | e4/a r. c8  | e4/g r. c8  | e4/g r.>g8  | b4/<g r. d8 | b4/g r
$bass:  r4        | d2.        | d            |>a          | a2~8    b8  |<c2.         | c           |>g           | g2
$beat:  c16 c c c | beats_1(3)  (quant 50) c8 c (quant 90) | c c c c c c | beats_1(3)                         c8 c | c  c c     c
