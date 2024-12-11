stones = '3279 998884 1832781 517 8 18864 28 0'.split(' ').map(&:to_i)

MEMO = {}

def memoized_stone_count(step, stone)
  MEMO[[step, stone]] ||= get_stone_count(step, stone)
end

def get_stone_count(step, stone)
  return 1 if step.zero?

  return get_stone_count(step - 1, 1) if stone.zero?

  log = Math.log10(stone).floor

  return get_stone_count(step - 1, stone * 2024) if log.even?

  mag = 10 ** (log / 2 + 1)
  leading = stone / mag
  memoized_stone_count(step - 1, leading) + memoized_stone_count(step - 1, stone - leading * mag)
end

puts(stones.sum do
  memoized_stone_count(1175, _1)
end)
