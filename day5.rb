input = ARGF.read

rules = input.split("\n\n").first.split("\n").map { |line| line.split('|').map(&:to_i) }

updates = input.split("\n\n").last.split("\n").map { _1.split(",").map(&:to_i) }

# task 1

puts(updates.sum do |update|
  correct = rules.all? do |a, b|
    next true unless update.include?(a) && update.include?(b)

    update.find_index(a) < update.find_index(b)
  end

  next 0 unless correct

  update[update.length / 2]
end)

# task 1

puts(updates.sum do |update|
  old_update = update.dup

  i = 0
  while(i < update.length)
    changed = false
    rules.each do |rule|
      next unless rule.last == update[i]
      next unless update[i..].include?(rule.first)

      update.insert(i, update.delete(rule.first))
      changed = true
    end

    i = i + 1 unless changed
    changed = false
  end

  next 0 if update == old_update

  update[update.length / 2]
end)
