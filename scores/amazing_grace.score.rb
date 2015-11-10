fade = Effect.define do |t, sound|
  pos = t/sound.frequency/sound.length
  if pos > 0.95
    [1-(pos-0.95)/0.05, 0].max*sound.sample_at(t)
  else
    [10*pos, 1].min*sound.sample_at(t)
  end
end

top_h = FreqSum[[1,0,0.75, :sine],[1,0,0.25, :triangle]] -> fade
top_l = FreqSum[[1,0,0.5, :triangle]] -> fade
bot_h = FreqSum[[1,0,0.5, :triangle]] -> fade
bot_l = FreqSum[[1,0,0.25, :square], [1,0,0.75,:sine]] -> fade

:<>:Amazing Grace:<>:

:master:  | (tempo 70) (volume 25)
top_h:    | o3 d | g2 a8 g | b2 a4 | g2 e4 | d2 d4 | g2 b8 g | b2 a4 |<d2~4|~4 r4>b4 |
top_l:    | o2 b | b2<d4   | d2 c4 |>b2 c4 | b2 b4 | b2<d4   | d2 d4 | d2~4|~4 r4 d4 |
bot_h:    | o2 g | d2 g4   | g2 f4 | g2 g4 | g2 g4 | d2 g4   | g2 f4 | g2~4|~4 r4 g4 |
bot_l:    | o1 g | g2 g8 b |<d2 d4 | e2 c4 |>g2 g4 | g2 g8 b |<d2 c4 |>b2~4|~4 r4 g4 |

top_h:  |<d.>b8<d>b | g2 d4 | e. g8 g  e | d2 d4 | g2 b8 g | b2 a4 | g2~4|~2~4 ||
top_l:  | d2    d4  | d2 d4 | c d   c    |>b2<d4 |>b2<d4   | d2 c4 |>b2~4|~2~4 ||
bot_h:  | b. g8 b g | g2 g4 | g2    e8 g | g2 g4 | g2 g8 b | g2 f4 | g2~4|~2~4 ||
bot_l:  |<g2    g4  |>b2 b4 |<c.>b8<c4   |>g2 b4 |<e2 d4   | d2 d4 |>g2~4|~2~4 ||
