MAP = File.read('./day20input.txt').split

def find(char) = MAP.each_with_index.filter_map { |line, y| (line =~ /#{char}/)&.then { [_1, y] } }[0]

START, FINISH = find('S'), find('E')

class Position
  attr_accessor :x, :y, :cost

  def initialize(x, y, cost)
    @x, @y, @cost = x, y, cost
  end

  def to_key = "#{x}-#{y}"

  def heuristic = (FINISH[0] - x).abs + (FINISH[1] - y).abs + cost

  def neighbors
    [[x-1,y],[x+1,y],[x,y-1],[x,y+1]]
      .filter { Position.at(_1, _2) != '#' }
      .map { Position.new(_1, _2, cost + 1) }
  end

  def self.at(x, y) = @@map[y][x]

  def self.find_shortest_path(map)
    start = Position.new(*START, 0)

    @@map = map
    @@done = {}
    @@todo = { start.heuristic => [start] }

    loop do
      cost = @@todo.keys.min

      @@todo.delete(cost).each do |position|
        return position.cost if at(position.x, position.y) == 'E'

        next if @@done[position.to_key]&.then { _1 < position.heuristic }
        @@done[position.to_key] = position.heuristic

        position.neighbors.each { @@todo[position.heuristic] = [*@@todo[position.heuristic], _1] }
      end
    end
  end
end

shortest_path_without_cheating = Position.find_shortest_path(MAP)
result = MAP.each_index.sum do |y|
  MAP[y].chars.each_index.count do |x|
    next if y < 1 || y >= MAP.length - 1
    next if x < 1 || x >= MAP[y].length - 1
    next unless MAP[y][x] == '#'

    puts [x, y].to_s

    map = MAP.map(&:dup).tap { _1[y][x] = '.' }
    new_shortest_path = Position.find_shortest_path(map)

    shortest_path_without_cheating - new_shortest_path >= 100
  end
end
puts result
