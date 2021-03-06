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
        elements.each do |e|
          if e.class == const
            return e
          end
          found = e.search const
          if found
            return found
          end
        end unless terminal?
        nil
      end

      def search_all const
        els = []
        elements.each do |e|
          els += [e] if e.class == const
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
      lines = (elements[1].find_all(AldaLine)+find_all(AldaLine)).select {|l| !l.empty?}
      score = {}
      lines.each do |line|
        sound = line.sound
        unless sound
          unless @sound
            puts line.value
            raise "no instrument selected"
          end
          sound = @sound
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
      str = "Stream.new({\n"
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
        if [MethodCall, Variable, Brackets, SetChord].include? e.class
          e.set_sound sound if e.is_a? SetChord
          res.push "{type: :stream, streams: #{e.value}}"
        elsif e.class == InlineEffect
          e.set_sound sound
          res.push "{type: :stream, streams: #{e.value}}"
        elsif e.class == Note
          res.push "{type: :sound#{", duration: #{e.duration}" if e.duration}, frequency: #{e.frequency}#{", chord: true" if e.chord?}#{", accidentals: #{e.accidentals.to_s}" if e.accidentals}}"
        elsif e.class == Special or e.class == ARest
          res.push "{type: :special, name: :#{e.name}#{", value: #{e.num}" if e.num}}"
        elsif e.class == OctaveUp or e.class == OctaveDown
          res.push "{type: :operator, value: :#{e.value}}"
        elsif e.class == ValSet
          res.push "{#{e.name}: (#{e.val})}"
        end
      end
      res
    end
  end

  class ANumber < Treetop::Runtime::SyntaxNode
  end

  class ARest < Treetop::Runtime::SyntaxNode
    def name
      :r
    end

    def num
      dur = find Duration
      if dur
        if dur.integer?
          dur.to_f
        else
          dur.vals
        end
      elsif dur = find(CurlyBrackets)
        '(' + dur.value[0..-2] + ')'
      end
    end
  end

  class Arguments < Treetop::Runtime::SyntaxNode
  end

  class Arrow < Treetop::Runtime::SyntaxNode
  end

  class ArrowExpression < Treetop::Runtime::SyntaxNode

    def value
      nest_str to_a
    end

    def nest_str arr
      if arr.length == 1
        arr[0].value
      else
        "Effect.new(#{nest_str arr[0..-2]}, #{arr[arr.length-1].value})"
      end
    end

    def to_a
      lhs = elements[0]
      rhs = elements[4]
      if rhs.is_a? ArrowExpression
        [lhs] + rhs.to_a
      else
        [lhs, rhs]
      end
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

  class DefAldaBlock < AldaBase
    def value
      title = find(ScoreTitle)
      (title ? title.value+"\n\n" : "") + "__streams.push " + super
    end
  end

  class AldaScore < DefAldaBlock
  end

  class Dot < Treetop::Runtime::SyntaxNode
  end

  class Duration < Treetop::Runtime::SyntaxNode
    def to_f
      base = 4.0/int
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
        elements[2].find(Duration).to_f
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
    def value
      :-
    end
  end

  class InlineEffect < AldaBase
    def set_sound sound
      @sound = sound
    end

    def value
      @sound = "Effect.new(#{@sound}, #{elements.last.value})"
      '[' + super + ']'
    end

  end

  class KindaHash < Treetop::Runtime::SyntaxNode
  end

  class Master < Treetop::Runtime::SyntaxNode
  end

  class MethodCall < Treetop::Runtime::SyntaxNode
  end

  class Natural < Treetop::Runtime::SyntaxNode
    def value
      :'='
    end
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
      elsif search(Pitch)
        dur = find CurlyBrackets
        if dur
          '(' + dur.value[1..-2] + ')'
        end
      else
        brks = find_all CurlyBrackets
        if brks.length == 2
          '(' + brks[1].value[1..-2] + ')'
        end
      end
    end

    def set_sound sound
      @sound = sound
    end

    def frequency
      pitch = search Pitch
      if pitch
        ':' + pitch.value
      else
        '(' + find(CurlyBrackets).value[1..-2] + ')'
      end
    end

    def accidentals
      if elements[1].elements.length > 0
        ret = elements[1].elements.map {|e| e.value }
      else
        nil
      end
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
  end

  class ScoreTitle < Treetop::Runtime::SyntaxNode
    def value
      "score_title = \"#{elements[1].value}\"\n"
    end
  end

  class SetChord < Note
    def value
      "method('#{elements[0].value + elements[1].value + elements[2].value}').call(#{@sound},#{duration || "nil"},#{chord?})"
    end
  end

  class Sharp < Treetop::Runtime::SyntaxNode
    def value
      :+
    end
  end

  class Space < Treetop::Runtime::SyntaxNode
  end

  class Special < Treetop::Runtime::SyntaxNode
    def name
      find(SpecialChar).value
    end

    def num
      if int = find(AInteger)
        Integer int.value
      elsif int = find(CurlyBrackets)
        '(' + int.value[1..-2] + ')'
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
        if e.is_a? DefAldaBlock
          e.header = @header
        end
        body += e.value
      end
      header + body + "  __streams\nend"
    end

    private

    def header
      "def #{@header.name}#{@header.args}\n" \
        "  __streams = []\n"
    end
  end

  class TonedefHeader < Treetop::Runtime::SyntaxNode
    def args
      find(Arguments).value
    end

    def name
      find(Variable).value
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
