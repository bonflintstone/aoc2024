MAP = File.read('./day20input.txt').split

def find(char) = MAP.each_with_index.filter_map { |line, y| (line =~ /#{char}/)&.then { [_1, y] } }[0]

START, FINISH = find('S'), find('E')

def at(x, y) = x.negative? || y.negative? ? '#' : MAP[y][x] rescue '#'

def valid_neighbors(x, y)
  [[x-1,y],[x+1,y],[x,y-1],[x,y+1]].filter { at(_1, _2) != '#' }
end

DISTANCE_BY_COORD = { FINISH => 0 }
TO_GRADE = valid_neighbors(*FINISH)

until TO_GRADE.empty? do
  x, y = TO_GRADE.pop

  distance = valid_neighbors(x, y).filter_map do |n|
    if DISTANCE_BY_COORD[n]
      DISTANCE_BY_COORD[n]
    else
      TO_GRADE << n
      nil
    end
  end.min.succ

  DISTANCE_BY_COORD[[x, y]] = distance
end

baseline = DISTANCE_BY_COORD[START]

puts(DISTANCE_BY_COORD.sum do |(x, y), dist_before_jump|
  (-20..20).sum do |dx|
    (-(20 - dx.abs)..(20 - dx.abs)).count do |dy|
      jump_distance = dx.abs + dy.abs

      distance_after_jump = DISTANCE_BY_COORD[[x + dx, y + dy]]

      next unless distance_after_jump

      saved = dist_before_jump - (distance_after_jump + jump_distance)

      saved >= 100
    end
  end
end)
