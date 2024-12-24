class Node
  class << self
    attr_accessor :net
  end

  attr_accessor :neighbours, :name

  def initialize(name)
    @name = name
    @neighbours = Set.new
  end

  def self.all = Set.new(Node.net.values)

  def inspect = "<Node name=#{name} neighbours_count=#{neighbours.size}>"

  def self.find_or_add(name) = Node.net[name] ||= Node.new(name)

  def self.add_link(name1, name2)
    n1, n2 = find_or_add(name1), find_or_add(name2)

    n1.neighbours.add(n2)
    n2.neighbours.add(n1)
  end
end
Node.net ||= {}
connections = File.read('./day23input.txt').split.each { Node.add_link(*_1.split('-')) }

def max_clique(r, p, x)
  return r if p.empty? && x.empty?

  result = nil
  p.each do |v|
    test = max_clique(r.union([v]), p.intersection(v.neighbours), x.intersection(v.neighbours))

    result = test if test && (result.nil? || test.size > result.size)

    p.delete(v)
    x.add(v)
  end
  result
end

result = max_clique(Set.new, Node.all, Set.new)

puts result.to_a.map(&:name).sort.join(',')
