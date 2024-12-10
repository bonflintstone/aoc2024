input = ARGF.read

MAP = input.split("\n").map(&:chars).map { _1.map(&:to_i) }

def get_heads(level, x, y)
  heads = []
  [[x-1, y], [x+1, y], [x, y-1], [x, y+1]].each do |new_x, new_y|
    next if new_x < 0 || new_y < 0
    new = MAP[new_x][new_y] rescue nil

    next if new == nil
    next if new != level + 1

    next heads << [new_x, new_y] if level + 1 == 9

    heads.push(*get_heads(level + 1, new_x, new_y))
  end
  heads
end

puts(0.upto(MAP.first.length - 1).each.flat_map do |x|
  0.upto(MAP.length - 1).each.flat_map do |y|
    next 0 if MAP[x][y] != 0

    get_heads(0, x, y).count
  end
end.sum)
