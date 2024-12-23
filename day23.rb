class Node
  class << self
    attr_accessor :net
  end

  attr_accessor :neighbours, :name

  def initialize(name)
    @name = name
    @neighbours = Set.new
  end

  def inspect = "<Node name=#{name} neighbours_count=#{neighbours.size}"

  def self.find_or_add(name) = Node.net[name] ||= Node.new(name)

  def self.add_link(name1, name2)
    n1, n2 = find_or_add(name1), find_or_add(name2)

    n1.neighbours.add(n2)
    n2.neighbours.add(n1)
  end
end
Node.net ||= {}
connections = File.read('./day23input.txt').split.each { Node.add_link(*_1.split('-')) }

subnets = Set.new
Node.net.values.each do |node|
  node.neighbours.each do |neighbour1|
    neighbour1.neighbours.each do |neighbour2|
      next unless neighbour2.neighbours.include?(node)

      candidate = [node.name, neighbour1.name, neighbour2.name]

      next unless candidate.any? { _1[0] == 't' }

      subnets.add(candidate.sort)
    end
  end
end
puts subnets.count
