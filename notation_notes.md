// define sounds

sound = 'filepath' -> fade_fx
bass = 'bass.wav'
...

// meta info

time-sig  = "4/4"
tempo     = 80

// define sections

bassline = (loudness=1) {
  bass {
    0   -> :C1 1/4
    2   -> :F1 1/8
    2.5 -> :E1 1/8
    3   -> :A0 1/4
  }
}

// score

|-
  bassline
|:2 tempo = 120
  // 0 -> assumed
  bassline 0.5 {
    bass :C0 1/4 1 // adds to
  }
  guitar_riff_0
:||
