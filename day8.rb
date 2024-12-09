antennas = ARGF.read.chars

antenna_types = antennas.uniq.filter { _1 != '.' && _1 != "\n" }

antinode_locations = []

antenna_types.each do |type|
  antenna_locations = antennas.each_with_index.filter_map { |a, i| a == type ? i : nil }
  antenna_locations.permutation(2).each do |l1, l2|
    anti_location = l2 + (l2 - l1)

    next if anti_location < 0 || anti_location >= antennas.length # oob y
    next if antennas[l1..l2].count("\n") != antennas[l2..anti_location].count("\n") # oob x
    next if antennas[l2..l1].count("\n") != antennas[anti_location..l2].count("\n") # oob x
    next if antennas[anti_location] == "\n"

    antinode_locations << anti_location
  end
end

antennas.each_with_index do |c, i|
  if antinode_locations.include?(i)
    print "#"
  else
    print c
  end
end

puts
puts antinode_locations.uniq.count
puts antennas.each_index.minmax
puts antinode_locations.sort.minmax.to_s
puts antinode_locations.uniq.count
