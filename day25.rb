schematics = File.read('./day25input.txt').split("\n\n").map { _1.split("\n") }

locks = []
keys = []

schematics.each do |schema|
  heights = schema[0].chars.each_index.map do |x|
    (0..schema.length - 1).each_cons(2).find_index do |y1, y2|
      schema[y1][x] != schema[y2][x]
    end
  end

  heights.map! { schema.length - _1 - 2 } if schema[0][0] == '.'

  if schema[0][0] == '.'
    locks << heights
  else
    keys << heights
  end
end

matches = locks.product(keys).count do |lock, key|
  lock.zip(key).map(&:sum).max <= 5
end

puts matches
