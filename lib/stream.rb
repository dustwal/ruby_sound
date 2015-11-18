require './lib/sound'
require './lib/rest'

class Stream

  DEFAULT_VALUES = {
    tempo: 120,
    channels: 2,
    pitch_set: PitchSet.new,
    octave: 4,
    quant: 90,
    pan: 50,
    duration: 1, # quarter note
    key: {},
    sample_rate: 44100,
    volume: 100
  }

  attr_reader :length

  def initialize map, len=Float::INFINITY
    @length = len
    @stream = map
    @stream[:master] ||= []
    @pos = Hash[map.keys.map{|k| [k, [0, 0]]}] # sound, pos (time), index
    @pos[:master] ||= [0,0]
    @values = Hash[map.keys.map{|k| [k, DEFAULT_VALUES.merge({})]}]
    @values[:master] = DEFAULT_VALUES.merge({volume: 100.0/1.27})
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

  def reset
    @pos = Hash[@pos.keys.map{|k| [k, [0, 0]]}] # sound, pos (time), index
    @pos[:master] ||= [0,0]
    @values = Hash[@values.keys.map{|k| [k, DEFAULT_VALUES.merge({})]}]
    @values[:master] = DEFAULT_VALUES.merge({volume: 100.0/1.27})
  end

  def copy
    ret = {}
    @values.each do |k,v|
      ret[k] = v.merge({})
    end
    ret
  end

  def samples
    samples = []
    while n = next_sound
      case n[:type]
      when :sound
        handle_sound n, samples
      when :stream
        puts "Stream: #{n[:sound]} s#{n[:start]} strs:#{n[:streams].length} 0:#{n[:streams][0].length}"
        start_index = time_to_samples n[:start], @values[n[:sound]][:sample_rate]
        n[:streams].each do |stream|
          stream.set_values({master: @values[:master].merge(@values[n[:sound]])})
          new_samps = stream.samples
          stream_len = (stream.length == Float::INFINITY ? new_samps.length : time_to_samples(stream.length*60.0/@values[n[:sound]][:tempo], @values[n[:sound]][:sample_rate]))
          new_samps = new_samps[0..stream_len]
          @pos[n[:sound]][0] += stream_len/Float(@values[n[:sound]][:sample_rate])
          expand_array samples, (start_index+new_samps.length)
          (0..new_samps.length-1).each do |i|
            samples[i+start_index] = Sample.new(new_samps[i]) + samples[i+start_index]
          end
          start_index += new_samps.length
        end
      when :attributes
        puts "ATTRS: #{n[:sound]} #{n[:attributes].to_s}"
        if n[:sound] == :master
          @values.each {|k,v| @values[k] = @values[k].merge n[:attributes]}
        else
          @values[n[:sound]].merge! n[:attributes]
        end
      when :special
        puts "Special: #{n[:sound]} #{n[:name]} #{n[:value]}"
        case n[:name]
        when :o
          @values[n[:sound]][:octave] = n[:value]
        when :j
          @pos[n[:sound]][0] += n[:value]*60.0/@values[n[:sound]][:tempo]
          vals = @values[n[:sound]]
          start_index = time_to_samples n[:start], vals[:sample_rate]
          end_index_full = start_index + Integer((n[:value]*60.0/vals[:tempo]*vals[:sample_rate]).round)
          expand_array samples, end_index_full
        when :r
          dur = n[:value]
          if dur.is_a? Hash
            dur = @values[n[:sound]][:duration]*(dur[:factor] || 1)+(dur[:add] || 0)
          elsif dur.nil?
            dur = @values[n[:sound]][:duration]
          end
          vals = @values[n[:sound]]
          start_index = time_to_samples n[:start], vals[:sample_rate]
          end_index_full = start_index + Integer((dur*60.0/vals[:tempo]*vals[:sample_rate]).round)
          expand_array samples, end_index_full
          @values[n[:sound]][:duration] = dur
          @pos[n[:sound]][0] += @values[n[:sound]][:duration]*60.0/@values[n[:sound]][:tempo]
        end
      when :operator
        puts "Operator: #{n[:value]}"
        if n[:value] == :<
          @values[n[:sound]][:octave] += 1
        elsif n[:value] == :>
          @values[n[:sound]][:octave] -= 1
        end
      else
      end
    end
    reset
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
    unless set_vals[:frequency].is_a? Numeric
      set_vals[:frequency] = 261.625565*(2**(set_vals[:octave]-4))*set_vals[:pitch_set].frequency_for(set_vals[:frequency])
      if set_vals[:accidentals]
        set_vals[:accidentals].each do |acc|
          set_vals[:frequency] = set_vals[:pitch_set].mod_with(acc).call set_vals[:frequency]
        end
      end
    end
    puts set_vals[:frequency]
    sound.set_values set_vals
    unless obj[:chord]
      @pos[sound][0] += sound.full_length
    end
    puts "Sound: #{sound} f:#{set_vals[:frequency]} d:#{set_vals[:duration]} s:#{set_vals[:start]}"
    start_index = time_to_samples obj[:start], vals[:sample_rate]
    end_index_full = start_index + Integer((sound.full_length*vals[:sample_rate]).round)
    expand_array samples, end_index_full
    sound.save

    sound_samples = sound.samples
    sound_samples.length.times do |i|
      samples[i+start_index] = sound_samples[i] + samples[i+start_index]
    end
  end

  def expand_array array, length
    if array.length < length
      (array.length..length-1).each{array.push [0.0, 0.0]}
    end
  end

  def beats_to_samples beats, tempo, sample_rate
    Integer beats*sample_rate*60.0/tempo
  end

  def time_to_samples t, sample_rate
    Integer((t*sample_rate).round)
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
      end
      obj[:start] = @pos[key][0]
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
