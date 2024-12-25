input, logic = File.read('./day24input.txt').split("\n\n")

input_wires = input.split("\n").each_with_object({}) { g, v = _1.split(': '); _2[g] = v == '1' }

logic_wires = logic.split("\n").map { _1.split }

def get_number(gates, char) = gates.keys.grep(/^#{char}/).sort.each_with_index.sum { gates[_1] ? 2 ** _2 : 0 }

def test(input_wires, logic_wires)
  gates = input_wires.dup
  changes = 1
  while (changes != 0) do
    changes = 0
    logic_wires.each do |g1, op, g2, _, g3|
      next unless gates.key?(g1) && gates.key?(g2) && 

      changes += 1 if !gates.key?(g3)
      gates[g3] = case op
        when 'AND' then gates[g1] && gates[g2]
        when 'OR' then gates[g1] || gates[g2]
        when 'XOR' then gates[g1] ^ gates[g2]
      end
    end
  end

  get_number(gates, 'z')
end

should_result = get_number(input_wires, 'x') + get_number(input_wires, 'y')
test_result = test(input_wires, logic_wires)

false_outputs = should_result.to_s(2).chars.zip(test_result.to_s(2).chars).each_with_index.filter_map do |(s, t), i|
  s == t ? nil : i
end

def get_all_false_gates(false_gates, logic_wires)
  false_gates.flatten.flat_map do |gate|
    [gate, get_all_false_gates(logic_wires.filter_map { _1[4] == gate && [_1[0], _1[2]] }, logic_wires)].compact
  end
end

all_false_gates = get_all_false_gates(false_outputs.map { "z#{_1.to_s.rjust(2, ?0)}" }, logic_wires)

binding.irb
