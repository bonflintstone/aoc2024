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

def ways_from_to(pad, current, new)
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

def get_segment_presses(pad, segment)
  pos = pad[:A]
  result = ['']
  segment.chars.map { pad[_1.to_sym] }.each do |new|
    result = ways_from_to(pad, pos, new).flat_map do |way|
      result.map { _1 + way }
    end
    pos = new
  end
  result
end

MEMO = {}
def seek(code, max_steps, step = 0)
  MEMO[[code, max_steps - step]] ||= begin
    return code.length if step == max_steps

    pad = step.zero? ? NUMERIC : DIRECTIONAL

    code.split(/(?<=A)/).sum do |segment| # split by A while keeping it
      get_segment_presses(pad, segment).map do |new_code|
        seek(new_code, max_steps, step.succ)
      end.min
    end
  end
end

puts(input.sum { seek(_1, 3) * _1.to_i })
puts(input.sum { seek(_1, 26) * _1.to_i })
