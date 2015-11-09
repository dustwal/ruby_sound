class Effect

  include Sound

  def initialize sound, effect
    @sound = sound
    @effect = effect
  end

  def sample_at t
    @effect.call t, @sound
  end

  def self.define &block
    Proc.new &block
  end

end
