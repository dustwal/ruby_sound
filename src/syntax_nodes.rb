module Treetop
  module Runtime
    class SyntaxNode
      def value
        if terminal?
          text_value
        else
          str = ""
          elements.each do |e|
            str += e.value
          end
          str
        end
      end

      def find const
        elements.each do |e|
          if e.class == const
            return e
          end
        end unless terminal?
        nil
      end

      def find_all const
        els = []
        elements.each do |e|
          if e.class == const
            els.push e
          end
        end unless terminal?
        els
      end

      def search const
        found = find const
        if found
          found
        else
          elements.each do |e|
            found = e.search const
            if found
              return round
            end
          end unless terminal?
          nil
        end
      end

      def search_all const
        els = find_all const
        elements.each do |e|
          els += e.search_all const
        end unless terminal?
        els
      end
    end
  end
end
module AldaRb

  class AString < Treetop::Runtime::SyntaxNode
  end

  class ASymbol < Treetop::Runtime::SyntaxNode
  end

  class AInteger < Treetop::Runtime::SyntaxNode
  end

  class AldaBase < Treetop::Runtime::SyntaxNode
    attr_accessor :header

    def value
      lines = search_all(AldaLine).select {|l| !l.empty?}
      score = {}
      sounds = @header ? @header.sounds : []
      cur = sounds.length > 0 ? 0 : nil
      lines.each do |line|
        sound = line.sound
        unless sound
          unless cur
            raise "no instrument selected"
          end
          sound = sounds[cur]
          cur = (cur+1)%sounds.length
        end
        line.set_sound sound
        notes = line.to_a
        if score[sound]
          score[sound] += notes
        else
          score[sound] = notes
        end
      end
      to_ruby score
    end

    def to_ruby score
      title = find ScoreTitle
      str = title ? title.value+"\n\n" : ""
      str += "__streams.push Stream.new({\n"
      i = 0
      score.each do |k,v|
        str += "  #{k} => [\n"
        v.each_with_index do |el, j|
          str += "    #{el}#{"," unless j == v.length-1}\n"
        end
        str += "  ]#{"," unless i == score.length-1}\n"
        i += 1
      end
      str + "})\n"
    end
  end

  class AldaBlock < AldaBase
  end

  class AldaComment < Treetop::Runtime::SyntaxNode
  end

  class AldaLine < Treetop::Runtime::SyntaxNode
    def empty?
      elements[2].elements.nil? ||
        elements[2].elements.select{|e| !e.is_a? Space and !e.is_a? AldaComment}.empty?
    end

    def set_sound sound
      @sound = sound
    end

    def sound
      if elements[1].elements
        elements[1].elements[0].value
      end
    end

    def to_a
      root = elements[2].elements.select{|e| !e.is_a? Space and !e.is_a? AldaComment}
      res = []
      root.each do |e|
        if e.class == MethodCall or e.class == Variable
          res.push "{type: :stream, streams: #{e.value}}"
        elsif e.class == Note
          res.push "{type: :sound#{", duration: #{e.duration}" if e.duration}, frequency: :#{e.frequency}#{", chord: true" if e.chord?}}"
        elsif e.class == Special
          res.push "{type: :special, name: :#{e.name}#{", value: #{e.num}" if e.num}}"
        elsif e.class == OctaveUp or e.class == OctaveDown
          res.push "{type: :operator, value: :#{e.value}}"
        elsif e.class == ValSet
          res.push "{#{e.name}: #{e.val}}"
        end
      end
      res
    end
  end

  class AldaScore < AldaBase
  end

  class ANumber < Treetop::Runtime::SyntaxNode
  end

  class Arguments < Treetop::Runtime::SyntaxNode
  end

  class Arrow < Treetop::Runtime::SyntaxNode
  end

  class ArrowExpression < Treetop::Runtime::SyntaxNode
    def value
      vals = []
      elements.each do |e|
        if e.is_a? Space or e.is_a? Arrow
          next
        else
          vals.push e.value
        end
      end
      "Effect.new(#{vals[0]}, #{vals[1]})"
    end
  end

  class Brackets < Treetop::Runtime::SyntaxNode
  end

  class Chord < Treetop::Runtime::SyntaxNode
  end

  class CommaSeparatedList < Treetop::Runtime::SyntaxNode
    def to_a
      extra = []
      if elements[1].elements
        extra = elements[1].elements[3].to_a
      end
      [elements[0].value] + extra
    end
  end

  class CurlyBrackets < Treetop::Runtime::SyntaxNode
  end

  class Dot < Treetop::Runtime::SyntaxNode
  end

  class Duration < Treetop::Runtime::SyntaxNode
    def to_f
      base = 4/int
      factor = dot_factor dots
      base * factor + additional
    end

    def vals
      vals = {}
      if dots > 0
        vals[:factor] = dot_factor dots
      end
      add = additional
      if add > 0
        vals[:add] = add
      end
      vals.length > 0 ? vals : nil
    end

    def additional
      if elements[2].elements
        elements[2].elements[2].to_f
      else
        0
      end
    end

    def int
      Integer(find(AInteger).value)
    end

    def dots
      elements[1].search_all(Dot).length
    end

    def integer?
      find(AInteger) ? true : false
    end

    private

    def dot_factor n
      r = 0
      (1+n).times do |i|
        r += 1.0/(2**i)
      end
      r
    end
  end

  class Flat < Treetop::Runtime::SyntaxNode
  end

  class KindaHash < Treetop::Runtime::SyntaxNode
  end

  class Master < Treetop::Runtime::SyntaxNode
  end

  class MethodCall < Treetop::Runtime::SyntaxNode
  end

  class Natural < Treetop::Runtime::SyntaxNode
  end

  class Note < Treetop::Runtime::SyntaxNode
    def duration
      dur = find Duration
      if dur
        if dur.integer?
          dur.to_f
        else
          dur.vals
        end
      end
    end

    def frequency
      find(Pitch).value.to_sym
    end

    def chord?
      find(Chord)? true : false
    end
  end

  class OctaveUp < Treetop::Runtime::SyntaxNode
  end

  class OctaveDown < Treetop::Runtime::SyntaxNode
  end

  class Pitch < Treetop::Runtime::SyntaxNode
  end

  class RubyBlock < Treetop::Runtime::SyntaxNode
  end

  class RubyCode < Treetop::Runtime::SyntaxNode
  end

  class ScoreRoot < Treetop::Runtime::SyntaxNode
    def value
      "require './score'\n\n" +
        "include WaveFile\n\n" +
        "__streams = []\n" +
        super() +
        "samps = []\n" +
        "__streams.each {|s| samps += s.samples}\n" +
        "buffer = Buffer.new samps, Format.new(:mono, :float, 44100)\n" +
        "Writer.new score_title.gsub(/[^a-zA-Z\\-\\_]/, \"\")+\".wav\", Format.new(:mono, :pcm_16, 44100) do |writer|\n" +
        "  writer.write buffer\n" +
        "end"
    end
  end

  class ScoreTitle < Treetop::Runtime::SyntaxNode
    def value
      "score_title = \"#{elements[1].value}\"\n"
    end
  end

  class Sharp < Treetop::Runtime::SyntaxNode
  end

  class Space < Treetop::Runtime::SyntaxNode
  end

  class Special < Treetop::Runtime::SyntaxNode
    def name
      find(SpecialChar).value
    end

    def num
      int = find AInteger
      if int
        Integer int.value
      else
        nil
      end
    end
  end

  class SpecialChar < Treetop::Runtime::SyntaxNode
  end

  class Tie < Treetop::Runtime::SyntaxNode
  end

  class Title < Treetop::Runtime::SyntaxNode
  end

  class Tonedef < Treetop::Runtime::SyntaxNode
    def value
      @header = find TonedefHeader
      body = ""
      find(Treetop::Runtime::SyntaxNode).elements.each do |e|
        if e.is_a? AldaBlock
          e.header = @header
        end
        body += e.value
      end
      header + body + "  __streams\nend"
    end

    private

    def header
      "def #{@header.name}#{@header.args}\n" \
        "  __length = #{@header.length}\n" \
        "  __streams = []\n"
    end
  end

  class TonedefBrackets < Treetop::Runtime::SyntaxNode
  end

  class TonedefHeader < Treetop::Runtime::SyntaxNode
    def args
      find(Arguments).value
    end

    def length
      Float(find(TonedefBrackets).find(ANumber).value)
    end

    def name
      find(Variable).value
    end

    def sounds
      find(TonedefBrackets).find(CommaSeparatedList).to_a
    end
  end

  class ValSet < Treetop::Runtime::SyntaxNode
    def name
      find(Variable).value
    end

    def val
      elements[4].value
    end
  end

  class Variable < Treetop::Runtime::SyntaxNode
  end

end
