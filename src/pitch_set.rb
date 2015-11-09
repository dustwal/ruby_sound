class PitchSet

  TET12 = {
    notes: {
      a: 2**(0/12),
      b: 2**(2/12),
      c: 2**(3/12),
      d: 2**(5/12),
      e: 2**(7/12),
      f: 2**(8/12),
      g: 2**(10/12)
    },
    mods: {
      :-    => Proc.new {|f| f/(2**(1.0/12))},
      :+    => Proc.new {|f| f*(2**(1.0/12))},
      :'='  => Proc.new {|f| f}
    }
  }

  def self.frequency_for sym, set=TET12
    set[:notes][sym]
  end

  def self.mod_with sym, set=TET12
    set[:mods][sym]
  end

end
