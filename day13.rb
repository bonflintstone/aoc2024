ARGF.read.split("\n\n").map do |lines|
  lines.split("\n").map { _1.scan(/\d+/).map(&:to_i) } => [x1, y1], [x2, y2], [x, y]

  # part 2
  x += 10000000000000
  y += 10000000000000

  a = (x * y2 - x2 * y) / (x1 * y2 - x2 * y1)
  b = (x1 * y - x * y1) / (x1 * y2 - x2 * y1)

  next unless a * x1 + b * x2 == x
  next unless a * y1 + b * y2 == y

  3 * a + b
end.compact.sum.tap { puts _1 }
