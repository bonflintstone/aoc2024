INPUT = ARGF.read

CHARS = INPUT.chars

COLS = INPUT.split("\n").first.length

def step(guard_pos, guard)
  next_pos = case guard
  when '^' then guard_pos - COLS - 1
  when 'v' then guard_pos + COLS + 1
  when '<' then guard_pos - 1
  when '>' then guard_pos + 1
  end

  return nil if next_pos >= INPUT.length
  return nil if next_pos < 0
  return nil if INPUT[next_pos] == "\n"
  next_pos
end

DIR_MAP = { '^' => 'u', '>' => 'r', 'v' => 'd', '<' => 'l' }
GUARD_MAP = { '^' => '>', '>' => 'v', 'v' => '<', '<' => '^' } 

def try_maze(maze)
  guard_pos = maze.find_index { DIR_MAP.keys.include?(_1) }

  loop do
    guard = maze[guard_pos]

    maze[guard_pos] = DIR_MAP[guard]

    next_pos = step(guard_pos, guard)
    return false if next_pos.nil?

    while maze[next_pos] == "#"
      guard = GUARD_MAP[guard]
      next_pos = step(guard_pos, guard)
      return false if next_pos.nil?
    end

    return true if maze[next_pos] == DIR_MAP[guard]

    maze[next_pos] = guard
    guard_pos = next_pos
  end
end

puts (CHARS.each_index.count do |i|
  next false if CHARS[i] != '.'

  maze = CHARS.dup.tap { _1[i] = '#' }

  next false unless try_maze(maze)

  true
end)
