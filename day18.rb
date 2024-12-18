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

  def trail = [*prev&.trail, [x, y]]

  def heuristic = (x - FINISH[0]).abs + (y - FINISH[1]).abs + step

  def step = trail.length - 1

  def to_s = "<Position x=#{x} y=#{y} step=#{step}>"

  def inspect = to_s

  def to_key = "#{x}-#{y}"

  def finish? = [x, y] == FINISH

  def next
    [[x-1, y], [x+1, y], [x, y+1], [x, y-1]]
      .filter { |x, y| x >= 0 && x <= FINISH[0] && y >= 0 && y <= FINISH[1] } # bounds
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
      return false if position.finish?

      next if prev.key?(position.to_key)

      prev[position.to_key] = position.heuristic
      position.next.each { totest[_1.heuristic] = [*totest[_1.heuristic], _1] }
    end
  end
end

result = (0..BYTES.length).bsearch do |cutoff|
  puts "Testing #{cutoff}.."
  test(cutoff)
end
puts BYTES[result].to_s
