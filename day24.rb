input, logic = File.read('./day24input.txt').split("\n\n")

GATES = {} # name: Input/ Gate

class Input
  attr_accessor :tags, :name, :value

  def initialize(name, value)
    @name, @value = name, value
    @tags = []
  end

  def inspect = "<Input:#{@name} o=#{get_output} tags=#{tags.tally}>"

  def to_s = "<Input:#{@name} o=#{get_output}>"

  def upstream = [self]

  def get_output = @value
end

class Gate
  attr_accessor :tags, :name

  def initialize(name, in1, in2, op, gates)
    @name, @in1, @in2, @op, @gates = name, in1, in2, op, gates
    @tags = []
  end

  def upstream = [self, *@gates[@in1].upstream, *@gates[@in2].upstream]

  def inspect = "<#{@name} o=#{get_output} tags=#{tags.tally} op=#{@op} in1=#{@gates[@in1]} in2=#{@gates[@in2]}>"

  def to_s = "<Gate:#{@name} o=#{get_output}>"

  def get_output 
    # puts [@gates[@in1], @gates[@in2]].map(&:get_output)
    [@gates[@in1], @gates[@in2]].map(&:get_output).reduce({AND: :&, OR: :|, XOR: :^}[@op.to_sym])
  end
end

class Machine
  def initialize(input, logic)
    @gates = {}
    input.split("\n").each { g, v = _1.split(': '); @gates[g] = Input.new(g, v.to_i) }
    logic.split("\n").each { g1, op, g2, _, g3 = _1.split; @gates[g3] = Gate.new(g3, g1, g2, op, @gates) }
  end

  def get_number(char) = @gates.keys.grep(/^#{char}/).sort.map { @gates[it] }.each_with_index.sum { _1.get_output * (2 ** _2) }

  def get_output(n)
    @gates["z#{n.to_s.rjust(2, '0')}"]
  end

  def compute(x = nil, y = nil)
    @gates.keys.grep(/^x/).sort.each_with_index do |g, i|
      @gates[g].value = x.to_s(2).reverse[i].to_i
    end unless x.nil?

    @gates.keys.grep(/^y/).sort.each_with_index do |g, i|
      @gates[g].value = y.to_s(2).reverse[i].to_i
    end unless y.nil?

    get_number('z')
  end
end

machine = Machine.new(input, logic)

SHOULD = (machine.get_number('x') + machine.get_number('y'))

current_swap = 
(1..10).each do |i|
  puts machine.get_output(i).upstream.count
  if machine.compute((2 ** i) - 1, 1) != 2 ** i
    puts machine.get_output(i)
    puts machine.get_output(i).upstream.count
    exit
  end
end

# SHOULD.to_s(2).chars.map11(&:to_i).reverse.each_with_index do |bit, i|
#   gate = GATES["z#{i.to_1s.rjust(2, '0')}"]
#   tag = gate.get_output == bit ? :good : :bad
#   gate.upstream.each { it.tags << tag }
# end
