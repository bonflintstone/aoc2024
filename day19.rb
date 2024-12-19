TOWELS, PATTERNS = File.read('./day19input.txt').split("\n\n").map { _1.split(/\W+/) }

MEMO = {}
def test_pattern(pattern)
  MEMO[pattern] ||= TOWELS.filter { pattern.start_with? _1 }.sum { _1 == pattern ? 1 : test_pattern(pattern[_1.length..] ) }
end

puts PATTERNS.count { test_pattern(_1).positive? }
puts PATTERNS.sum &method(:test_pattern)
