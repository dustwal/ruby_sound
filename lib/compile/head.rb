require './score'

include WaveFile
include ARB::EFX
include ARB::Chords

__master = { master: {
    sample_rate: Integer(ARGV[0] || 44100)
  }
}

__streams = []
