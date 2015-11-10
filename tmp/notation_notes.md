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

bassline = [1:bass] () {
  o1 c2 f8 e >a4
}

guitar_riff_0 = [1:guitar] (n) {
  o4 e16 e e e f8 a ..
  if n==1
    .. <c b a4
  else
    .. <c4 c
}

// score signal as such (different rules for score vs code (mainly w/ bars))

|-
  bassline
|:2 tempo = 120
  // 0 -> assumed
  bassline 0.5 {
    bass :C0 1/4 1 // adds to
  }
  guitar_riff_0
:||

| bassline |
|          |
- tempo<-120
|:2 bassline v.5  :||
|:  guitar_riff_0 :||


master: |       tempo 120~|:2                 :|~tempo 80 ||
bass:   | bassline {o0 c} |: bassline v.5     :| bassline ||
guitar: |                 |: guitar_riff_0(n) :|          ||
piano:  | o3 c c g g      |:                  :| a a g2   ||

| bassline |:2 bassline v.5 :| bassline ||
|tempo 120~|: guitar_riff_0 :|~tempo    ||

//at least need:

| main ||
