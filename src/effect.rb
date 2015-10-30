class Effect

  include Sound

  def initialize sound, effect
    @sound = sound
    @effect = effect
  end

  def sample_at t
    @effect.call t
  end

end
