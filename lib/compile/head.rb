require './score'

include WaveFile
include ARB::EFX

__master = { master: {
    sample_rate: Integer(ARGV[0] || 44100)
  }
}

__streams = []
