TOWELS, PATTERNS = File.read('./day19input.txt').split("\n\n").map { _1.split(/\W+/) }

MEMO = {}
def test_pattern(pattern)
  MEMO[pattern] ||= begin
    return 1 if pattern.empty?

    TOWELS
      .filter { pattern.start_with? _1 }
      .map { pattern[_1.length..] }
      .sum { test_pattern(_1) }
  end
end

puts PATTERNS.count { test_pattern(_1).positive? }
puts PATTERNS.sum &method(:test_pattern)
