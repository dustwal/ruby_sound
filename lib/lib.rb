require './score'

module ARB

  module Chords

    PITCH12 = [:c, :'c+', :'d-', :d, :'d+', :'e-', :e, :f, :'f+',
               :'g-', :g, :'g+', :'a-', :a, :'a+', :'b-', :b]

    def chord sound, intervals, duration, base, accid, chord
      first = {type: :sound, frequency: base, accidentals: accid, chord: true}
      if duration
        first[:duration] = duration
      end
      arr = []
      intervals.each do |interval|
        arr.push(first.merge({accidentals: (accid + interval)}))
      end
      arr[-1][:chord] = chord
      [Stream.new({sound => arr})]
    end

    def major_triad sound, duration, base, accid, chord
      chord sound, [[],Array.new(4,:+),Array.new(7,:+)], duration, base, accid, chord
    end

    def minor_triad sound, duration, base, accid, chord
      chord sound, [[],Array.new(3,:+),Array.new(7,:+)], duration, base, accid, chord
    end

    def diminished_triad sound, duration, base, accid, chord
      chord sound, [[],Array.new(3,:+),Array.new(6,:+)], duration, base, accid, chord
    end

    def augmented_triad sound, duration, base, accid, chord
      chord sound, [[],Array.new(4,:+),Array.new(8,:+)], duration, base, accid, chord
    end

    PITCH12.each do |sym|
      {"M" => "major_triad", "m" => "minor_triad",
       "dim" => "diminished_triad", "aug" => "augmented_triad"}.each do |str, metho|
        define_method "#{sym}#{str}" do |sound, duration, chord|
          case sym.to_s[-1]
          when "s"
            accidentals = [:+]
          when "f"
            accidentals = [:-]
          else
            accidentals = []
          end
          method(metho).call sound, duration, sym, accidentals, chord
        end
      end
    end

  end

  module EFX

    def position t, sound
      t/sound.frequency/sound.length
    end

    def power_fade n
      Proc.new do |t,sound|
        ((1-position(t,sound))**n)*sound.sample(t)
      end
    end

    def inverse_power_fade n
      Proc.new do |t,sound|
        (1-(position(t,sound)**n))*sound.sample(t)
      end
    end

    def binaural_beats hz
      Proc.new do |t,sound|
        lsample = sound.sample(t*(sound.frequency-(hz/2.0))/sound.frequency).left
        rsample = sound.sample(t*(sound.frequency+(hz/2.0))/sound.frequency).right
        Sample.new [lsample, rsample]
      end
    end

    def shape_set set
      Proc.new do |t,sound|
        pos = position t, sound
        val_set = [[0.0,0.0]] + set + [[1.0,0.0]]
        index = 0
        val_set.length.times do |i|
          if pos > val_set[i][0]
            index = i
          else
            break
          end
        end
        Sample.new(((pos-val_set[index][0])/(val_set[index+1][0]-val_set[index][0])*(val_set[index+1][1]-val_set[index][1])+val_set[index][1])*sound.sample(t))
      end
    end

    def sine_pan hz, amp=1.0
      Proc.new do |t,sound|
        realt = t/sound.frequency
        pan = 0.5 + Math.sin(realt*hz*2*Math::PI)/2.0*amp
        sample = sound.sample t
        Sample.new [pan*sample.left, (1-pan)*sample.right]
      end
    end

    def sine_vol hz, amp=1.0
      Proc.new do |t,sound|
        realt = t/sound.frequency
        ((1.0-amp)+(amp*Math.sin(realt*hz*2*Math::PI)))*sound.sample(t)
      end
    end

    def id
      Proc.new do |t,sound|
        sound.sample t
      end
    end

    # NOTE super slow. put last
    def echo time, damp
      Proc.new do |t,sound|
        realt = t/sound.frequency
        lastt = realt
        samp = 0
        i = 1
        while (lastt = lastt - time) > 0
          samp = (damp**i)*sound.sample(lastt*sound.frequency) + samp
          i += 1
        end
        Sample.new(sound.sample(t) + samp)
      end
    end

  end

end
