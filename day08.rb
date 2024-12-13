antennas = ARGF.read.chars

antenna_types = antennas.uniq.filter { _1 != '.' && _1 != "\n" }

antinode_locations = []

antenna_types.each do |type|
  antenna_locations = antennas.each_with_index.filter_map { |a, i| a == type ? i : nil }
  antenna_locations.combination(2).each do |l1, l2|
    diff = l2 - l1

    anti_location = l2
    anti_location -= diff while (anti_location >= 0)
    breaks_in_diff = antennas[l1..l2].count("\n")
    breaks_before_l1 = antennas[..l1].count("\n")

    while (anti_location <= antennas.length - diff) do # oob y
      anti_location += diff

      diff_difference = (l1 - anti_location) / diff
      breaks_before_anti = antennas[..anti_location].count("\n")

      next unless breaks_before_anti + breaks_in_diff * diff_difference === breaks_before_l1
      next if antennas[anti_location] == "\n"

      antinode_locations << anti_location
    end
  end
end

puts antinode_locations.uniq.count
