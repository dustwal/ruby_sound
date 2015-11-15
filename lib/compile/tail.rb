samps = []
__streams.each do |stream|
  stream.set_values __master
  samps += stream.samples
end
channels = samps[0].is_a?(Array) ? samps[0].length : 1
buffer = Buffer.new samps, Format.new(channels, :float, __master[:master][:sample_rate])
Writer.new score_title.gsub(/[^a-zA-Z0-9\-\_]/, "")+".wav",
  Format.new(channels, :pcm_16, __master[:master][:sample_rate]) do |writer|
  writer.write buffer
end
