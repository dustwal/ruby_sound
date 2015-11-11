require './lib/sound'
require './lib/rest'

class Stream

  DEFAULT_VALUES = {
    tempo: 120,
    channels: 1,
    pitch_set: PitchSet.new,
    octave: 4,
    quant: 90,
    pan: 50,
    duration: 1, # quarter note
    key: {},
    volume: 100
  }

  attr_accessor :sample_rate
  attr_reader :length

  def initialize map, len=Float::INFINITY
    @length = len
    @stream = map
    @stream[:master] ||= []
    @pos = Hash[map.keys.map{|k| [k, [0, 0]]}] # sound, pos (time), index
    @pos[:master] ||= [0,0]
    @values = Hash[map.keys.map{|k| [k, DEFAULT_VALUES.merge({})]}]
    @values[:master] = DEFAULT_VALUES.merge({volume: 100.0/1.27})
    @sample_rate = 44100
  end

  def set_values hash
    if hash.has_key? :master
      @values.each_key do |k|
        @values[k] = @values[k].merge hash[:master]
      end
    end
    hash.each do |k, v|
      if @values.has_key? k
        @values[k] = @values[k].merge v
      else
        @values[k] = v.merge({})
      end
    end
  end

  def samples
    samples = []
    while n = next_sound
      puts "#{n[:type]} #{n[:sound]} #{n[:start]} #{n[:duration]}"
      case n[:type]
      when :sound
        handle_sound n, samples
      when :stream
        start_index = time_to_samples n[:start]
        n[:streams].each do |stream|
          stream.set_values @values.select{|k,v| k==:master or k==n[:sound]} # TODO figure out how I want to pass evironment
          new_samps = stream.samples
          stream_len = (stream.length == Float::INFINITY ? new_samps.length : time_to_samples(stream.length*60.0/@values[n[:sound]][:tempo]))
          new_samps = new_samps[0..stream_len]
          @pos[n[:sound]][0] += stream_len/Float(@sample_rate)
          expand_array samples, (start_index+new_samps.length)
          (0..new_samps.length-1).each do |i|
            samples[i+start_index] += new_samps[i]
          end
          start_index += new_samps.length
        end
      when :attributes
        if n[:sound] == :master
          @values.each {|k,v| @values[k] = @values[k].merge n[:attributes]}
        else
          @values[n[:sound]].merge! n[:attributes]
        end
      when :special
        case n[:name]
        when :o
          @values[n[:sound]][:octave] = n[:value]
        when :r
          if n[:value]
            dur = n[:value]
            if dur.is_a? Hash
              dur = @values[n[:sound]][:duration]*(dur[:factor] || 1)+(dur[:add] || 0)
            end
            @values[n[:sound]][:duration] = dur
          end
          @pos[n[:sound]][0] += @values[n[:sound]][:duration]*60.0/@values[n[:sound]][:tempo]
        end
      when :operator
        if n[:value] == :<
          @values[n[:sound]][:octave] += 1
        elsif n[:value] == :>
          @values[n[:sound]][:octave] -= 1
        end
      else
      end
    end
    samples
  end

  private

  def handle_sound obj, samples
    sound = obj[:sound]
    vals = @values[sound]
    if obj[:duration]
      dur = obj[:duration]
      if dur.is_a? Hash
        obj[:duration] = vals[:duration]*(dur[:factor] || 1)+(dur[:add] || 0)
      end
      @values[sound][:duration] = obj[:duration]
    end
    set_vals = vals.merge obj
    set_vals[:frequency] = 261.625565*(2**(set_vals[:octave]-4))*set_vals[:pitch_set].frequency_for(set_vals[:frequency])
    sound.set_values set_vals
    unless obj[:chord]
      @pos[sound][0] += @values[sound][:duration]*60.0/vals[:tempo]
    end
    start_index = time_to_samples obj[:start]
    end_index = start_index + Integer(sound.length*@sample_rate)
    expand_array samples, end_index
    (start_index..end_index-1).each do |sample|
      samples[sample] += sound.sample(Float(sample-start_index)/@sample_rate)
    end
  end

  def expand_array array, length
    if array.length < length
      (array.length..length-1).each{array.push 0.0}
    end
  end

  def beats_to_samples beats, tempo
    Integer beats*@sample_rate*60.0/tempo
  end

  def time_to_samples t
    Integer((t*@sample_rate).round)
  end

  def next_sound
    master_pos = @pos[:master]
    pos = Float::INFINITY
    min_pos = @pos.select {|k,v| k != :master}
    min_min = get_min_key min_pos
    if not min_min and master_pos[0] == Float::INFINITY
      nil
    else
      next_help ((not min_min or master_pos[0] <= @pos[min_min][0]) ? :master : min_min)
    end
  end

  def next_help key
    if @pos[key][1] >= @stream[key].length
      @pos[key] = [Float::INFINITY, -1]
      next_sound
    else
      obj = @stream[key][@pos[key][1]]
      case obj[:type]
      when nil
        obj = {type: :attributes, attributes: obj}
      when :sound
        obj[:start] = @pos[key][0]
      when :stream
        obj[:start] = @pos[key][0]
      end
      @pos[key][1] += 1
      obj[:sound] = key
      obj
    end
  end

  def get_min_key map
    min_k = nil
    min_v = Float::INFINITY
    map.each do |k,v|
      if v[0] < min_v
        min_v = v[0]
        min_k = k
      end
    end
    min_k
  end

end
