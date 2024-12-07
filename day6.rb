INPUT = ARGF.read

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

loop do
  guard_pos = INPUT =~ /\^|v|>|</
  guard = INPUT[guard_pos]

  INPUT[guard_pos] = 'o'

  next_pos = step(guard_pos, guard)
  break if next_pos.nil?

  if INPUT[next_pos] == "#"
    guard = { '^' => '>', '>' => 'v', 'v' => '<', '<' => '^' }[guard]
    next_pos = step(guard_pos, guard)
    break if next_pos.nil?
  end

  INPUT[next_pos] = guard

  puts INPUT
  puts
end

puts INPUT.count('o')
