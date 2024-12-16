MAZE = File.read('./day16input.txt').split

UP = [0, -1]
LEFT = [-1, 0]
RIGHT = [1, 0]
DOWN = [0, 1]

class Position
  attr_accessor :x, :y, :dir, :cost, :prev
  def initialize(x, y, dir, cost = 0, prev = nil)
    @x, @y, @dir, @cost, @prev = x, y, dir, cost, prev
  end

  def heuristic = cost + (FINISH[0] - x).abs + (FINISH[1] - y).abs

  def tile = MAZE[y][x]

  def trail = [[x, y], *prev&.trail]

  def to_key = "#{x}-#{y}-#{dir.to_s}"

  def neighbours
    turn_dirs = dir[0].zero? ? [LEFT, RIGHT] : [UP, DOWN]
    [
      Position.new(x + dir[0], y + dir[1], dir,          cost + 1,    self),
      Position.new(x,          y,          turn_dirs[0], cost + 1000, self),
      Position.new(x,          y,          turn_dirs[1], cost + 1000, self)
    ].filter { _1.tile != '#' }
  end
end

def find(char) = MAZE.each_with_index.filter_map { |line, y| (line =~ /#{char}/)&.then { [_1, y] } }[0]

def add(position) = NEXT[position.heuristic] = [*NEXT[position.heuristic], position]

START, FINISH = find('S'), find('E')

NEXT, PAST, BEST = {}, {}, []

add(Position.new(START[0], START[1], RIGHT))
loop do
  heuristic = NEXT.keys.min

  break if BEST.any? && heuristic > BEST[0].cost

  NEXT.delete(heuristic).each do |position|
    past = PAST[position.to_key]
    if past.nil?
      PAST[position.to_key] = position
    elsif past.heuristic < position.heuristic
      next
    end

    next BEST << position if position.tile == 'E'

    position.neighbours.each { add(_1) }
  end
end

puts BEST.first.cost
puts BEST.flat_map(&:trail).uniq.count
