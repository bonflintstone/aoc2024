puts(ARGF.count do |l|
  r = l.split.map &:to_i
  r.each_index.any? do |i|
    r1 = r.dup
    r1.delete_at i

    [1..3,-3..-1].any? { |range| r1.each_cons(2).all? { range.include? _1 - _2 } }
  end
end)
