input, logic = File.read('./day24input.txt').split("\n\n")

GATES = {} # name: Input/ Gate

class Parent
  def inspect = "<#{self.class.name} #{name} #{op} => #{child_ops}>"

  def to_s = inspect

  def child_ops
    GATES.values.filter { it.in1 == name || it.in2 == name }.map(&:op).sort
  end
end

class Input < Parent
  attr_accessor :tags, :overwrite, :name, :in1, :in2

  def initialize(name, value)
    @name, @value = name, value
    @tags = []
  end

  def upstream = [self]

  def op = :in

  def get_output 
    return overwrite unless overwrite.nil?
    @value
  end
end

class Gate < Parent
  attr_accessor :tags, :overwrite, :name, :op, :in1, :in2

  def initialize(name, in1, in2, op)
    @name, @in1, @in2, @op = name, in1, in2, op
    @tags = []
  end

  def upstream
    [self, *GATES[@in1].upstream, *GATES[@in2].upstream]
  end

  def get_output 
    return overwrite unless overwrite.nil?

    [GATES[@in1], GATES[@in2]].map(&:get_output).reduce({AND: :&, OR: :|, XOR: :^}[@op.to_sym])
  end
end

input.split("\n").each { g, v = _1.split(': '); GATES[g] = Input.new(g, v.to_i) }
logic.split("\n").each { g1, op, g2, _, g3 = _1.split; GATES[g3] = Gate.new(g3, g1, g2, op) }

binding.irb
