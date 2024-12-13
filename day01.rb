list1, list2 = ARGF.map { _1.split.map(&:to_i) }.transpose

puts list1.sort.zip(list2.sort).sum { (_1 - _2).abs }

puts list1.sum { _1 * list2.count(_1) }
