input = ARGF.read

map = []
input.chars.each_with_index do |c, i|
  item = i.even? ? (i / 2) : nil
  map.push(*([item] * c.to_i))
end

loop do
  break # part 1
  first_free = map.find_index('.')
  last_taken = map.length - map.reverse.find_index { _1 != nil} - 1

  break if first_free > last_taken

  map[first_free] = map[last_taken]
  map[last_taken] = nil

  puts first_free * 1000 / map.length
end

file_pointer = map.length - 1

puts map.to_s

(0..map.compact.max).to_a.reverse.each do |id|
  free_pointer = 0
  puts 'finding file with id ' + id.to_s
  file_pointer -= 1 until map[file_pointer] == id

  # puts file_pointer

  puts 'find file end pointer'
  file_end_pointer = file_pointer;
  file_end_pointer -= 1 until map[file_end_pointer] != id || file_end_pointer < 0

  file_size = file_pointer - file_end_pointer;
  puts "file size: #{file_size}"

  # puts({ free_pointer:, file_size: })
  # puts free_pointer..(free_pointer + file_size)
  # puts map.length

  puts 'find free'
  free_pointer += 1 until map.slice(free_pointer, file_size) == [nil] * file_size || free_pointer >= map.size

  next if free_pointer > file_pointer
  
  map[free_pointer..(free_pointer + file_size - 1)] = [id] * file_size
  map[(file_end_pointer + 1)..(file_end_pointer + file_size)] = [nil] * file_size
end

puts map.to_s
checksum = map.map(&:to_i).each_with_index.sum { _1 * _2 }
puts checksum
