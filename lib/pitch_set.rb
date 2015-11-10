class PitchSet

  TET12 = {
    notes: {
      c: 2**(0.0/12),
      d: 2**(2.0/12),
      e: 2**(4.0/12),
      f: 2**(5.0/12),
      g: 2**(7.0/12),
      a: 2**(9.0/12),
      b: 2**(11.0/12)
    },
    mods: {
      :-    => Proc.new {|f| f/(2**(1.0/12))},
      :+    => Proc.new {|f| f*(2**(1.0/12))},
      :'='  => Proc.new {|f| f}
    }
  }

  def initialize set=TET12
    @pset = set
  end

  def frequency_for sym
    @pset[:notes][sym]
  end

  def mod_with sym
    @pset[:mods][sym]
  end

  def self.frequency_for sym, set=TET12
    set[:notes][sym]
  end

  def self.mod_with sym, set=TET12
    set[:mods][sym]
  end

end
