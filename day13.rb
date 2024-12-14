puts(ARGF.read.split("\n\n").sum do
  x1, y1, x2, y2, x, y = _1.scan(/\d+/).map &:to_i

  x += 10000000000000
  y += 10000000000000

  div = x1 * y2 - x2 * y1

  a = (x * y2 - x2 * y) / div
  b = (x1 * y - x * y1) / div

  next 0 unless a * x1 + b * x2 == x

  3 * a + b
end)
