registers, program = File.read('./day17input.txt').split("\n\n").map { _1.scan(/\d+/).map(&:to_i) }

class Computer
  def initialize(registers, program)
    @registers, @program = registers, program
    @pointer = 0
    @output = []
  end

  def get_combo
    case op = @program[@pointer.succ]
    when 0..3
      op
    when 4..6
      @registers[op - 4]
    else
      raise 'Combo op 7 encountert'
    end
  end

  def get_literal = @program[@pointer.succ]

  def run
    until @pointer >= @program.length
      step
    end
    @output
  end

  def step
    case @program[@pointer]
    when 0 #adv
      @registers[0] /= (2 ** get_combo)
    when 1 #bxl
      @registers[1] = @registers[1] ^ get_literal
    when 2 #bst
      @registers[1] = get_combo % 8
    when 3 #jnz
      return @pointer = get_literal unless @registers[0].zero?
    when 4 #bxc
      @registers[1] = @registers[1] ^ @registers[2]
    when 5 #out
      @output << get_combo % 8
    when 6 #bdv
      @registers[1] = @registers[0] / (2 ** get_combo)
    when 7 #cdv
      @registers[2] = @registers[0] / (2 ** get_combo)
    end

    @pointer += 2
  end
end

# some manual "binary" search was required to come up with this
(0b110_101_110_010_001_110_110_000_001_000_000_000_000_000_000_000..).each do |i|
  new_registers = [i, registers[1..]]
  output = Computer.new(new_registers, program).run

  break puts i if program == output
end
