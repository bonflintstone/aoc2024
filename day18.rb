BYTES = File.read('./day18input.txt').scan(/\d+/).map(&:to_i).each_slice(2).to_a

START = [0, 0]
FINISH = [70, 70]

class Position
  class << self
    attr_accessor :cutoff
  end

  attr_accessor :x, :y, :prev

  def initialize(x, y, prev)
    @x, @y, @prev = x, y, prev
  end

  def heuristic = (x - FINISH[0]).abs + (y - FINISH[1]).abs + step

  def step = prev ? prev.step.succ : 0

  def to_key = "#{x}-#{y}"

  def finish? = [x, y] == FINISH

  def next
    [[x-1, y], [x+1, y], [x, y+1], [x, y-1]]
      .filter { _1 >= 0 && _1 <= FINISH[0] && _2 >= 0 && _2 <= FINISH[1] } # bounds
      .filter { !BYTES[..Position.cutoff].include?(_1) } # bytes
      .map { Position.new(*_1, self) }
  end
end

def test(cutoff)
  Position.cutoff = cutoff

  start = Position.new(*START, nil)
  totest = { start.heuristic => [start] }
  prev = {}

  loop do
    key, positions = totest.min
    totest.delete(key)

    return true unless positions&.any?

    positions.each do |position|
      if position.finish?
        puts position.step if Position.cutoff == 1024
        return false
      end

      next if prev.key?(position.to_key)

      prev[position.to_key] = position.heuristic
      position.next.each { totest[_1.heuristic] = [*totest[_1.heuristic], _1] }
    end
  end
end

test(1024)

result = (0..BYTES.length).bsearch { test(_1) }
puts BYTES[result].to_s
