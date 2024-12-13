input = ARGF.read

OPS = [
  -> (a, b) { a + b },
  -> (a, b) { a * b },
  -> (a, b) { "#{a}#{b}".to_i } # task 2
]

def search(current, rest, test)
  return test == current if rest.empty?

  OPS.any? do |op|
    search(op.call(current, rest.first), rest[1..], test)
  end
end

puts(input.split("\n").sum do |line|
  line.scan(/\d+/).map(&:to_i) => test, first_input, *inputs

  search(first_input, inputs, test) ? test : 0
end)
