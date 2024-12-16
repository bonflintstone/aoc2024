# 1

puts ARGF.read.scan(/mul\((\d+),(\d+)\)/).sum { _1.to_i * _2.to_i }

# 2

all_regex = /(mul\(\d+,\d+\))|(do\(\))|(don't\(\))/

flip = true

puts(input.scan(all_regex).map(&:compact).map(&:first).sum do |match|
  case match
  when 'do()'
    flip = true 
    0
  when 'don\'t()'
    flip = false 
    0
  else
    next 0 unless flip

    match.scan(mul_regex).first.map(&:to_i).reduce(&:*)
  end
end)
