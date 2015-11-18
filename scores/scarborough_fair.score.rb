
#Vocals
$tenor0 = FreqSum[[1,0,1,:sine]] -> (inverse_power_fade(2))
$tenor1 = FreqSum[[1,0,1,:sine]] -> (inverse_power_fade(2))
$baritone = FreqSum[[1,0,0.8,:sine],[1,0,0.2,:triangle]] -> (inverse_power_fade(2))

#Instruments
$guitar = (Guitar.new 3) -> (power_fade(2))
$guitar_low = (Guitar.new 5) -> (power_fade(1))
$piano_right = FreqSum[[1,0,1,:sine]] -> (power_fade(2))
$piano_left = FreqSum[[1,0,1,:sine]] -> (power_fade(1))
$bass = FreqSum[[1,0,0.75,:sine],[1,0,0.25,:triangle],[2,0,0.5,:sine]] -> (sine_pan(3.0, 0.3)) -> (inverse_power_fade(3))

tonedef guitar_high_bar_1 ()
  ::= $guitar: r8 b d c+ a d =::
fin

tonedef guitar_high_bar_2 ()
  ::= $guitar: r8 b e>b<f+ e =::
fin

tonedef guitar_high_bar_3 ()
  ::= $guitar: r8 b e>b<f+ d =::
fin

tonedef piano_accent ()
  ::= $piano_right: | r4 g4. e8 |~4 f+4. d8 |~4 r2 | =::
fin

tonedef melody_1 (sound)
::=
sound: | e2  e4 | b2~8 b8 | f+4. g8 f+4 | e2.   |~2   r4 |
sound: | r>b<d  | e2 d4   |>b  <c+ >a   | b2.   |~2.     | r2.  |
sound: | r2 <e4 | e2 e4   | d2     >b4  | b a g | f+8 d~2|~4 r2 |
sound: | e   b4 | a2 g4   | f+  e   d   | e2.   |~2.     | r2. r|
=::
fin

tonedef right_piano_1 ()
::= $piano_right: | r8. e32/g a e8/g f+ e/g r | =::
fin

tonedef right_piano_2 ()
::= $piano_right: | r8.<c16>g8/b a g/b r | =::
fin

tonedef right_piano_pair (n)
  if n > 1
    ::= $piano_right: | r8.<e16/g e8/g f+ e/g r | =::
  end
  ::= $piano_right: | r8. e16 e8/g f+ e/g r | =::
fin

tonedef left_piano_eb ()
::= $piano_left: | e2./r8 b~2 | =::
fin

$gh_1 = guitar_high_bar_1
$gh_2 = guitar_high_bar_2
$gh_3 = guitar_high_bar_3
$t0_melody = melody_1 $tenor0
$t1_melody = melody_1 $tenor1
$bt_melody = melody_1 $baritone
$piano_accent = piano_accent
$piano_right_1 = right_piano_1
$piano_right_2 = right_piano_2
$piano_left_eb = left_piano_eb
$piano_rpair_1 = right_piano_pair 1
$piano_rpair_2 = right_piano_pair 2

# took score from:
#https://musescore.com/jessedavidsykes/scarboroughfaircanticleaccompaniedmalechorus#

:<>:Scarborough Fair:<>:

:master:      (tempo 135) (volume 12)
$tenor0:       o4 | j21
$tenor1:       o4 | j21
$baritone:     o3 | j21
$guitar:       o4 |
$guitar_low:   o4 |
$piano_right:  o6 | j30
$piano_left:   o3 | j93
$bass:         o2 | j99

$guitar:      | $gh_1 | $gh_1 | r8 f d2 | $gh_1 | $gh_2 | $gh_1 | $gh_2 |
$guitar_low:  | e2.   | a     | g2 f+4  | e2.   | e     | e     | e     |

$tenor0:      | $t0_melody
$tenor1:      | $t1_melody
$baritone:    | $bt_melody
$guitar:      | $gh_1 | $gh_3   | f+8 d>f+ g/<g>g4/<f+ | $gh_1 | $gh_3 |
$guitar_low:  | e     | e       | d                    | e     | e     |
$piano_right:                                          | $piano_accent |

$guitar:      | r8 b d>b<g d | r b e>b<g d | b d<c+>e a4 | $gh_1 | $gh_2 | $gh_1 |
$guitar_low:  | g            | e           | g4 a2       | e2.   | e     | e     |
$piano_right: |              | j6                        | $piano_accent j39     |

$guitar:      | $gh_2 | r8 b e>b4. | r8<b d>b<g d | b4 a  g | f+8 d>f+<d g/>b<d | g4/>b a2/<f+ |
$guitar_low:  | e     | e2   e8 f+ | g2.          | g4 f+ e | d2.               |~2      d4    |

$guitar:      | r8 b e>b<e b | f+ d>f+<d g/>b<d | f+4/>a a16/<f+ g/>b a4./<f+ | $gh_1 | $gh_2 | $gh_1 | $gh_2 |
$guitar_low:  | e2.          | d                |~2                   d4      | e2.   | e     | e     | e     |

$tenor0:      | e8 e4.        e4 | b    b    b    | f+    g      f+    | e2.            | r                 |
$tenor1:      | r2.              | r2        d8 e | f+4   e      f+    | g    f+   e    | f+      e      d  |
$baritone:    | e8 e4.        e4 | e    e    e    | d2           d4    | e2.            | r                 |
$guitar:      | $gh_1            | $gh_3          | f+8 d g/>b<d f+4/a | $gh_1          | $gh_3             |
$guitar_low:  | e                | e              | d                  | e              | e                 |
$piano_right: | r4 e8/g f+ e/g r | $piano_right_1 | r4  d8/f+ e d/f+ r | $piano_rpair_1 | $piano_right_2    |
$piano_left:  | $piano_left_eb   | $piano_left_eb | d2./r8 a~2         | $piano_left_eb | $piano_left_eb    |
$bass:        |                                   | d4    d      d     | e2        b4   | e4.         b8 e4 |

$tenor0:      | r4  >b  <d     | e2      d4     |>b    <c+  >a      | b2.            | r              |
$tenor1:      |>b2      <r4    | j6                                 |<d   e    c+    | c+  >b  <c+    |
$baritone:    | r4   g   a     | a   g   g      | g     a    a      | b2.            | r              |
$guitar:      | r8 b d>b<g d   | r b e>b<g d    | b d  <c+>e a4     | $gh_1          | $gh_2          |
$guitar_low:  | g              | e              | g4    a2          | e2.            | e              |
$piano_right: | $piano_right_2 | $piano_right_1 | r8 f+ e>a<d>b     |<$piano_rpair_2                  |
$piano_left:  | g2./r8<d~2     |>$piano_left_eb | g4/r8<d>a2/r8<e4. |>$piano_left_eb | $piano_left_eb |
$bass:        | e2.            |<e             >|>g4    a    a      |<e. >b8   b4    |<e.  >b8  b4    |

$tenor0:      | r        | r2   e4 |              e2     e4        | d2          >b4  | b      a         g      |
$tenor1:      | d  c+>a  | b2   r4 |              j6                                  | d4     e         g      |
$baritone:    | r        | r2   g4 |              g2     g8 a      | b2           a4  | g      f+        e      |
$guitar:      | $gh_1    | $gh_2   |              r8 b e>b4.       | r8<b   d>  b<g d | b4     a         g      |
$guitar_low:  | e        | e       |              e2     e8 f+     | g2.              | g4     f+        e      |
$piano_right: | $piano_rpair_2     |              r2.              | r8 g/b g/b a g4  | g8/b a g g16/a b g8/a g |
$piano_left:  | $piano_left_eb | $piano_left_eb | e2/r8 b4.  e8 f+ | g2./r8 b~2       | g4     f+        e      |
$bass:        |<e.>b8 b4 |<e.>b8 b4 |             e2    <e8 f+     | g2.             >|>g4     a         b      |

$tenor0:      | f+8 d~2          | r2.          | e2       b4    | a2         g4     | f+    e               d     | e2.                     |
$tenor1:      | a     f+  d      | f+    e   d  | e   >b2        | r2.               | r                           |<e4        f+      g     |
$baritone:    | d2.              | r            | e2       g4    | f+2        e4     | d     e               f+    | e2.                     |
$guitar:      | f+8 d>a<d g/>b<d | g4/>b a2/<f+ | r8 b e>b<b e   | f+ d>a<d   g/>b<d | f+4/>a a16/<f+ g/>b a4./<f+ | $gh_1                   |
$guitar_low:  | d2.              |~2         d4 | e2.            | d                 |~2                     d4    | e2.                     |
$piano_right: | d8./f+ e16 d2    | r2.          | $piano_rpair_1 | r4 d8/f+ e d/f+ r | r8. d16/f+ d8/f+ e  d/f+ r  | r8. g16/b g8/b a  g/b r |
$piano_left:  | d2.~2/r8 f+~2    | r4 f+2/r4 d  | $piano_left_eb | d2.~2/r8 a~2      | r2                    d4    | $piano_left_eb          |
$bass:        |<d2       >a4     |<d4.   >a8<d4 | e2.            |<d                 |>d4    d               d     | e4.            d8 e   d |

$tenor0:      | j9                                                                          | e8 e4.  e4     | b        a       g     |
$tenor1:      | a          g       f+    | g         f+     d     | e2                  r4  | r2.            | r2               d8 e  |
$baritone:    | j9                                                                          | e8 e4.  e4     | e        e       e     |
$guitar:      | $gh_2                    | $gh_1                  | $gh_2                   | $gh_1          | $gh_3                  |
$guitar_low:  | e                        | e                      | e                       | e              | e                      |
$piano_right: | r8. g16/<e e8/>g<d>g/b r | r8. e16/a e8/a g e/a r | r8. e32/g a e8/g f+ e r | r4>e8 g b4     | r8 e16 e g b<e d>b8 f+ |
$piano_left:  | $piano_left_eb           | $piano_left_eb         | $piano_left_eb          | $piano_left_eb | $piano_left_eb         |
$bass:        | e4.              d8 e  d | e4.            d8 e  d | e4. d8 e d              | e2.            |>e                      |

$tenor0:      | f+    g      f+     | e2.              | r2.               | r4       b   <d   | e2            d4  |>b   <c+  >a  |
$tenor1:      | f+4   e      f+     | g        f+   e  | f+       e    d   |>b2            r4  | r2.               | r            |
$baritone:    | d     d      d      | e2.              | r                 | r4       g    a   | a        g    g   | g    a    a  |
$guitar:      | f+8 d g/>b<d f+4/>a | $gh_1            | $gh_3             | r8 b     d> b<g d | r  b     d> b<g d | b d <c+>e a4 |
$guitar_low:  | d                   | e                | e                 | g                 | e                 | g4   a2      |
$piano_right: | r8  d a/<f+ d>f+ d  | r8 e16 e b8<e>b4 | r8 e16 e b8<g e>b | r8 d16 d<d8 b g d | r8>g16 b<e8 g b g | r8>d b<e d>b |
$piano_left:  | d2./r8 a~2          | $piano_left_eb   | $piano_left_eb    | g2./r8 b~2        | $piano_left_eb    |>g4/<d e2/>a  |
$bass:        | d     d      d      | e2           >b4 |<e4.        >b8<e4 | g2.               |<e                >|>g4   a    a  |
