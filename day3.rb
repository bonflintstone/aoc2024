input = ARGF.read

mul_regex = /mul\((\d+),(\d+)\)/

# Task 1
# puts input.scan(mul_regex).sum { |a| a.first.to_i * a.last.to_i }

all_regex = /(mul\(\d+,\d+\))|(do\(\))|(don't\(\))/

flip = true

puts(input.scan(all_regex).map(&:compact).map(&:first).sum do |match|
  if match == 'do()'
    flip = true 
    next 0
  end
  if match == 'don\'t()'
    flip = false 
    next 0
  end

  next 0 unless flip

  match.scan(mul_regex).first.then { _1.map(&:to_i).reduce(&:*) }
end)
