include ARB::EFX
sound = FreqSum[[1,0,1,:sine]] -> (inverse_power_fade(2))

:<>:test:<>:

sound: | (volume 50) o2 c1~1 c4 c c8 c c c |
