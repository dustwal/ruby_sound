require 'treetop'
require './src/syntax_nodes'

Treetop.load 'src/alda_plus_parser'
f = File.open 'test_notation.score'


parser = AldaRbParser.new
tree = parser.parse f.read

unless tree
  puts parser.failure_reason
end
