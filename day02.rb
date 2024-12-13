input =  ARGF.read

reports = input.split("\n").map { _1.split(' ').map(&:to_i) }
puts(reports.count do |report|
  report.each_index.any? do |i|
    considered_report = report.dup.tap { _1.delete_at(i) }

    next false unless considered_report == considered_report.sort || considered_report == considered_report.sort.reverse

    considered_report.each_cons(2).all? { |a, b| (a - b).abs.then { _1 >= 1 && _1 <= 3 } }
  end
end)
