sound = FreqSum[[1,0,1,:sine]] -> (ARB::EFX.echo 1, 0.95) -> (ARB::EFX.power_fade 3)

:<>:test:<>:

sound: | (volume 50) o2 c1~1 c1~1 |
