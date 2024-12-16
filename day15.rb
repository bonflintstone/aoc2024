DIR = { '>': [1, 0], 'v': [0, 1], '^': [0, -1], '<': [-1, 0] }

map, moves = File.new('./day15input.txt').read.split("\n\n")
MAP = map.split("\n").map do |line|
  line.chars.map do |char|
    case char
    when 'O'
      '[]'
    when '@'
      '@.'
    else
      char * 2
    end
  end.join
end

def at(x, y) = MAP[y][x]

def swap(x1, y1, x2, y2)
  tmp = at(x1, y1)
  MAP[y1][x1] = MAP[y2][x2]
  MAP[y2][x2] = tmp
end

def show = MAP.each { puts _1 }

def positions_of(char)
  MAP.each_with_index.filter_map do |line, i|
    line.chars.each_with_index.filter_map { _1 == char && [_2, i] }
  end.flatten(1)
end

def stones_to_move(x, y, vx, vy)
  nx = x + vx
  ny = y + vy

  block = at(x, y)

  if block == '#'
    false
  elsif block == '[' && vx == 0
    [
      *stones_to_move(nx, ny, vx, vy),
      *stones_to_move(nx + 1, ny, vx, vy),
      [x + 1, y],
      [x, y]
    ]
  elsif block == ']' && vx == 0
    [
      *stones_to_move(nx, ny, vx, vy),
      *stones_to_move(nx - 1, ny, vx, vy),
      [x, y],
      [x - 1, y]
    ]
  elsif block == '.'
    []
  else
    [*stones_to_move(nx, ny, vx, vy), [x, y]]
  end
end

moves.chars.each do |move|
  next unless DIR.keys.include?(move.to_sym)

  vx, vy = DIR[move.to_sym]
  positions_of('@').first => x, y

  stones = stones_to_move(x, y, vx, vy).uniq
  next unless stones.all?

  stones.each do |sx, sy|
    swap(sx, sy, sx + vx, sy + vy)
  end
end

puts positions_of('[').sum { _1 + _2 * 100 }
