require './score.rb'

def super_octave
  ws = WaveSum.new
  21.times do |i|
    ws.waves.push Wave.new(1.0/(2**(i-10)), 0, 1.0/21, :sine)
  end
  ws
end

def sine_dec
  ws = WaveSum.new
  gran = 100
  start = 1
  gran.times do |i|
    power = 2**(i/10.0)
    amp = sin(2*Math::PI/10.0*i)
    ws.waves.push Wave.new(1.0/power, 0, amp*0.5/(gran+1), :sine)
    ws.waves.push Wave.new(power, 0, amp*0.5/(gran+1), :sine)
  end
  ws
end

def make_sum
  sine_dec
end

SumFile.save make_sum, 'audio/waves/updowntriangle_flat.freq'
