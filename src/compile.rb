require 'treetop'
require './src/syntax_nodes'

Treetop.load 'src/alda_plus_parser'
fin = File.open ARGV[0]

unless fin
  STDOUT.puts "error loading file #{ARGV[0]}"
  exit
end

strout = ""

parser = AldaRbParser.new
tree = parser.parse fin.read

unless tree
  STDOUT.puts parser.failure_reason
  exit
end

fout = File.open "out_compiled_test.rb", "w"
if fout
  fout.write tree.value
end
