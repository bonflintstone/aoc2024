input, logic = File.read('./day24input.txt').split("\n\n")

GATES = {} # name: Input/ Gate

class Input
  attr_accessor :tags, :overwrite, :name

  def initialize(name, value)
    @name, @value = name, value
    @tags = []
  end

  def inspect = "<Input:#{@name} o=#{get_output} tags=#{tags.tally}>"

  def to_s = "<Input:#{@name} o=#{get_output}>"

  def upstream = [self]

  def get_output 
    return overwrite unless overwrite.nil?
    @value
  end
end

class Gate
  attr_accessor :tags, :overwrite, :name

  def initialize(name, in1, in2, op)
    @name, @in1, @in2, @op = name, in1, in2, op
    @tags = []
  end

  def upstream
    [self, *GATES[@in1].upstream, *GATES[@in2].upstream]
  end

  def inspect
    "<#{@name} o=#{get_output} tags=#{tags.tally} op=#{@op} in1=#{GATES[@in1]} in2=#{GATES[@in2]}>"
  end

  def to_s = "<Gate:#{@name} o=#{get_output}>"

  def get_output 
    return overwrite unless overwrite.nil?

    [GATES[@in1], GATES[@in2]].map(&:get_output).reduce({AND: :&, OR: :|, XOR: :^}[@op.to_sym])
  end
end

input.split("\n").each { g, v = _1.split(': '); GATES[g] = Input.new(g, v.to_i) }
logic.split("\n").each { g1, op, g2, _, g3 = _1.split; GATES[g3] = Gate.new(g3, g1, g2, op) }

OUTPUT_GATES = GATES.keys.grep(/^z/).sort.map { GATES[it] }

def get_number(char) = GATES.keys.grep(/^#{char}/).sort.map { GATES[it] }.each_with_index.sum { _1.get_output * (2 ** _2) }

def get_z = OUTPUT_GATES.each_with_index.sum { _1.get_output * (2 ** _2) }

SHOULD = (get_number('x') + get_number('y'))

puts SHOULD.to_s(2)

SHOULD.to_s(2).chars.map(&:to_i).reverse.each_with_index do |bit, i|
  gate = GATES["z#{i.to_s.rjust(2, '0')}"]
  tag = gate.get_output == bit ? :good : :bad
  gate.upstream.each { it.tags << tag }
end

bad_true, bad_false = GATES.values.sort_by { -it.tags.count(:bad) }.filter { it.tags.include?(:bad) }.partition { it.get_output != 0 }

def score(result) = SHOULD.to_s(2).chars.zip(result.to_s(2).chars).filter { _1 != _2 }.count

DEFAULT_SCORE = score(get_number('z'))

def reset = GATES.values.each { it.overwrite = nil }

def score_swap(swaps)
  reset
  swaps.each { it[0].overwrite = it[1] }
  score(get_number('z'))
end

bad_true.filter! { score_swap([[it, 0]]) < DEFAULT_SCORE - 1 }
bad_false.filter! { score_swap([[it, 1]]) < DEFAULT_SCORE - 1 }

best_score = 1000
bad_true.combination(4).each_with_index do |truths, i|
  # puts [i, best_score].to_s
  bad_false.combination(4).each do |falses|
    score = score_swap((truths + falses).zip([0, 0, 0, 0, 1, 1, 1, 1]))

    best_score = [best_score, score].min

    if score == 1
      puts get_number('z').to_s(2)
      # binding.irb
      # puts (truths + falses).map(&:name).sort.join(',')
    end
  end
end
