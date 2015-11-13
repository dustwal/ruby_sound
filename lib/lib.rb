require './score'

module ARB

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
        pan = 0.5 + Math.sin(realt*hz*2*Math::PI)/2.0
        sample = sound.sample t
        Sample.new [pan*sample.left, (1-pan)*sample.right]
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
