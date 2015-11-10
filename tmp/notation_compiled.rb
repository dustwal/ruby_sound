require 'whatever'

$score = $score.new

sound = Sound.new Sound.new('filepath'), fade_fx
bass = Sound.new 'base.wav'

time-sig  = TimeSig.new "4/4"
tempo     = 80

def bassline start, loudness=1
  $score.add(bass start,     :C1, 0.25,  loudness)
  $score.add(bass start+2,   :F1, 0.125, loudness)
  $score.add(bass start+2.5, :E1, 0.125, loudness)
  $score.add(bass start+3,   :A0, 0.25,  loudness)
end

counter = 0
Measure.new do
  bassline TimeSig.pos(counter)
  counter += 1
end
tempo = 120
2.times do
  Measure.new do
    bassline TimeSig.pos(counter), 0.5 do
      $score.add (bass TimeSig.pos(counter), :C0, 0.25, 1)
    end
    guitar_riff_0
    counter += 1
  end
end

$score.save "filename"
