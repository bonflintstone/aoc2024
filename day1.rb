input =  ARGF.read

list1, list2 = input.split("\n").map do |line|
  line.split(' ').map(&:to_i)
end.each_with_object([[], []]) do |(a, b), arr|
  arr.first << a
  arr.last << b
end

list1.sort!
list2.sort!

# Task 1
puts(list1.zip(list2).map do |a, b|
  [a - b, b - a].max
end.sum)

puts(list1.sum do |a|
  a * list2.count { |b| b == a }
end)
