require './score'

module ARB

  module EFX

    def self.position t, sound
      t/sound.frequency/sound.length
    end

    def self.power_fade n
      Proc.new do |t,sound|
        ((1-position(t,sound))**n)*sound.sample(t)
      end
    end

    def self.inverse_power_fade n
      Proc.new do |t,sound|
        (1-(position(t,sound)**n))*sound.sample(t)
      end
    end

    def self.binaural_beats hz
      Proc.new do |t,sound|
        lsample = sound.sample(t*(sound.frequency-(hz/2.0))/sound.frequency).left
        rsample = sound.sample(t*(sound.frequency+(hz/2.0))/sound.frequency).right
        Sample.new [lsample, rsample]
      end
    end

    def self.sine_pan hz
      Proc.new do |t,sound|
        realt = t/sound.frequency
        pan = 0.5 + Math.sin(realt*hz*2*Math::PI)/2.0
        sample = sound.sample t
        Sample.new [pan*sample.left, (1-pan)*sample.right]
      end
    end

    def self.echo time, damp
      Proc.new do |t,sound|
        realt = t/sound.frequency
        last_samp = realt >= time ? damp*sound.sample((realt - time)*sound.frequency) : 0
        Sample.new(sound.sample(t) + last_samp)
      end
    end

  end

end
