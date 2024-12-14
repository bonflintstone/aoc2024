WIDTH = 101
HEIGHT = 103
STEPS = 100

def part1
  ARGF.map do |line|
    x, y, vx, vy = line.scan(/-?\d+/).map(&:to_i)
    x, y = [(x + vx * STEPS) % WIDTH, ((y + vy * STEPS) % HEIGHT)]
    [x <=> (WIDTH / 2), y <=> (HEIGHT / 2)]
  end
    .filter { !_1.any?(&:zero?) }
    .tally.values.reduce(:*).tap { puts _1 }
end

def part2
  input = ARGF.to_a
  0.upto(100000).each do |steps|
    next unless steps % 103 == 1

    positions = input.map do |line|
      x, y, vx, vy = line.scan(/-?\d+/).map(&:to_i)
      [(x + vx * steps) % WIDTH, ((y + vy * steps) % HEIGHT)]
    end.tally

    puts
    puts steps
    0.upto(WIDTH).each do |x|
      0.upto(HEIGHT).each do |y|
        count = positions[[x, y]] || 0
        if count == 0
          print "\e[30m#{count}\e[0m"
        elsif count == 1
          print "\e[42m#{count}\e[0m"
        else
          print "\e[41m#{count}\e[0m"
        end
      end
      puts
    end
    sleep 0.1
  end
end

part2
