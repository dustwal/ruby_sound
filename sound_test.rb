require 'ruby-audio'

RubyAudio::Sound.open 'piano.wav' do |snd|
  buf = snd.read :int
  puts buf.real_size
end
