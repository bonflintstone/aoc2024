input = File.read('./day21input.txt').split

NUMERIC = {
  '7': [0, 0], '8': [1, 0], '9': [2, 0],
  '4': [0, 1], '5': [1, 1], '6': [2, 1],
  '1': [0, 2], '2': [1, 2], '3': [2, 2],
               '0': [1, 3], 'A': [2, 3],
}

DIRECTIONAL = {
               '^': [1, 0], 'A': [2, 0],
  '<': [0, 1], 'v': [1, 1], '>': [2, 1],
}

WAYS_MEMO = {}
def ways_from_to(pad, current, new)
  WAYS_MEMO[[pad, current, new]] ||= begin
    cx, cy = current
    nx, ny = new

    return ['A'] if current == new
    return [] unless pad.values.include?(current)

    [].tap do |result|
      result.push(*ways_from_to(pad, [cx, cy + 1], new).map { 'v' + _1 }) if cy < ny
      result.push(*ways_from_to(pad, [cx + 1, cy], new).map { '>' + _1 }) if cx < nx
      result.push(*ways_from_to(pad, [cx, cy - 1], new).map { '^' + _1 }) if cy > ny
      result.push(*ways_from_to(pad, [cx - 1, cy], new).map { '<' + _1 }) if cx > nx
    end.compact
  end
end

def evaluate(pad, code)
  x, y = pad[:A]
  result = ''
  code.chars.each do |char|
    raise 'hell' if pad.invert[[x, y]] == nil
    x += 1 if char == '>'
    x -= 1 if char == '<'
    y += 1 if char == 'v'
    y -= 1 if char == '^'
    result << pad.invert[[x, y]].to_s if char =='A'
  end
  result
end

def get_presses(pad, codes)
  codes.flat_map do |code|
    old = pad[:A]
    result = ['']
    code.chars.map { pad[_1.to_sym] }.each do |new|
      result = ways_from_to(pad, old, new).flat_map do |way|
        result.map { _1 + way }
      end
      old = new
    end
    result
  end
end

puts(input.sum do |line|
  codes = get_presses(NUMERIC, [line])

  2.times do
    codes = get_presses(DIRECTIONAL, codes)

    min_length = codes.map(&:length).min
    puts codes.map(&:length).tally

    codes.filter! { _1.length == min_length }

    puts codes.length
  end

  codes.first.length * line.to_i
end)
