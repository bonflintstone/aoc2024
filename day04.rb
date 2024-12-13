input = ARGF.read.split("\n")

# task 1

occurences = 0

WORD = 'XMAS'

def find_vertical(grid)
  grid.each_cons(WORD.length).sum do |lines|
    max = lines.map(&:length).max
    cols = (0..max).map { |i| lines.map { _1[i] }.compact.reduce(&:+) }
    cols.filter { _1 == WORD || _1 == WORD.reverse }.count
  end
end

left_skewed_grid = input.each_with_index.map { |line, i| line.then { _1.chars.unshift(' ' * (input.length - i)).join } }

right_skewed_grid = input.each_with_index.map { |line, i| line.then { _1.chars.unshift(' ' * i).join } }

occurences += input.sum { |line| line.scan(WORD).count + line.scan(WORD.reverse).count } # find horizontal
occurences += find_vertical(input)
occurences += find_vertical(left_skewed_grid)
occurences += find_vertical(right_skewed_grid)

puts occurences

# task 2

puts(input.each_cons(3).sum do |lines|
  lines.first.chars.each_index.count do |i|
    chars = [lines[0][i], lines[0][i + 2], lines[1][i + 1], lines[2][i], lines[2][i + 2]].join rescue ''

    result = chars == 'MSAMS' || chars == 'MMASS' || chars == 'SMASM' || chars == 'SSAMM'
    result
  end
end)
