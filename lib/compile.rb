require 'treetop'
require './lib/syntax_nodes'

Treetop.load 'lib/alda_plus_parser'
filepath = ARGV[0]
filepath_out = filepath.split(".")[0] + ".rb"
fin = File.open ARGV[0]
fhead = File.open 'lib/compile/head.rb'
ftail = File.open 'lib/compile/tail.rb'

unless fin
  STDOUT.puts "error loading file #{ARGV[0]}"
  exit
end

parser = AldaRbParser.new
tree = parser.parse fin.read
fin.close
unless tree
  STDOUT.puts parser.failure_reason
  exit
end

fout = File.open filepath_out, "w"
if fout
  fout.write fhead.read + tree.value + ftail.read
end

fout.close
fhead.close
ftail.close
