INPUT = ARGF.read.split("\n").map(&:chars)

TASK_2 = true

class Cell
  attr_reader :x, :y
  attr_accessor :plant, :plot_id, :processed

  def to_s
    "<Cell x=#{x} y=#{y} plant=#{plant} plot_id=#{plot_id}>"
  end

  def initialize(x, y)
    @x = x
    @y = y
    @plant = INPUT[x][y]
    Cell.all[[x, y]] = self
  end

  def neighbour_coords
    [[x-1,y],[x+1,y],[x,y+1],[x,y-1]]
  end

  def self.all = @@cells ||= {}

  def self.at(x, y) = all[[x, y]]

  def self.next_plot_id
    @@plot_id ||= 0
    @@plot_id += 1
  end
end

INPUT.each_index { |x| INPUT[x].each_index { |y| Cell.new(x, y) } }

SIDES = {}

def initialize_cells(cell, plot_id = nil)
  return if cell.plot_id
  cell.plot_id = plot_id || Cell.next_plot_id

  cell.neighbour_coords.each do |x, y|
    neighbour = Cell.at(x, y)
    next if neighbour.nil? || neighbour.plant != cell.plant || neighbour.plot_id
    initialize_cells(neighbour, cell.plot_id)
  end
end
Cell.all.values.each { initialize_cells(_1) }

def get_area_and_sides(cell)
  result = { a: 0, s: 0 }

  return result if cell.processed
  cell.processed = true

  result[:a] += 1

  cell.neighbour_coords.each do |nx, ny|
    if Cell.at(nx, ny)&.plot_id != cell.plot_id
      if ny == cell.y
        unless TASK_2 && Cell.at(cell.x, ny - 1)&.plot_id == cell.plot_id && Cell.at(nx, ny - 1)&.plot_id != cell.plot_id
          result[:s] += 1
        end
      end
      if nx == cell.x
        unless TASK_2 && Cell.at(nx - 1, cell.y)&.plot_id == cell.plot_id && Cell.at(nx - 1, ny)&.plot_id != cell.plot_id
          result[:s] += 1
        end
      end
    else
      next if Cell.at(nx, ny).nil?
      get_area_and_sides(Cell.at(nx, ny)) => a:, s:
      result[:a] += a
      result[:s] += s
    end
  end

  result
end

result_by_plot_id = {}
Cell.all.values.each do |cell|
  next unless result_by_plot_id[cell.plot_id].nil?

  result_by_plot_id[cell.plot_id] = get_area_and_sides(cell)
end

puts result_by_plot_id.values.sum { _1.values.reduce(:*) }
