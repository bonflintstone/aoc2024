MAP = File.read('./day20input.txt').split

FINISH = MAP.each_with_index.filter_map { |line, y| (line =~ /E/)&.then { [_1, y] } }.first

def at(x, y) = x.negative? || y.negative? ? '#' : MAP[y][x] rescue '#'

def valid_neighbors(x, y) = [[x-1,y],[x+1,y],[x,y-1],[x,y+1]].filter { at(_1, _2) != '#' }

DISTANCE_BY_COORD = { FINISH => 0 }
TO_GRADE = valid_neighbors(*FINISH)

while TO_GRADE.any? do
  pos = TO_GRADE.pop

  to_grade, graded = valid_neighbors(*pos).partition { !DISTANCE_BY_COORD[_1] }

  TO_GRADE.push(*to_grade)

  DISTANCE_BY_COORD[pos] = graded.map { DISTANCE_BY_COORD[_1] }.min.succ
end

def get_good_jump(max, wanna_save)
  DISTANCE_BY_COORD.sum do |(x, y), dist_before_jump|
    (-max..max).sum do |dx|
      (-(max - dx.abs)..(max - dx.abs)).count do |dy|
        distance_after_jump = DISTANCE_BY_COORD[[x + dx, y + dy]]

        next unless distance_after_jump

        dist_before_jump - (distance_after_jump + dx.abs + dy.abs) >= wanna_save
      end
    end
  end
end

puts get_good_jump(2, 100)
puts get_good_jump(20, 100)
