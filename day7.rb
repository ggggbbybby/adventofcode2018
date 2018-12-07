constraints = <<TXT
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
TXT

constraints = File.read("day7.txt")

constraints = constraints.split("\n").map { |c| /Step (\w) must be finished before step (\w) can begin./.match(c)[1..2] }

steps = constraints.flatten.uniq.sort

prereqs = Hash.new {|h,k| h[k] = [] }
constraints.each do |a, b|
  prereqs[b] << a
end

completed = []
while completed.length < steps.length
  completed << steps.detect { |s| !completed.include?(s) && (prereqs[s] - completed).empty? }
end

puts "Part 1: #{completed.join}"

def duration(step)
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ".index(step) + 1 + 60
end

started = {}
now = 0
startable = []

elf_assignments = {
  one: nil,
  two: nil,
  three: nil,
  four: nil,
  five: nil
}

completed = []
while completed.length < steps.length
  # check for completed assignments
  elf_assignments.each do |elf, assignment|
      if assignment && started[assignment] + duration(assignment) <= now
        completed << assignment
        elf_assignments[elf] = nil
      end
  end

  # calculate startable assignments *after* marking off completed ones
  startable = steps.select { |s| !completed.include?(s) && !started[s] && (prereqs[s] - completed).empty? }

  # assign any not-busy elves to startable assignments
  elf_assignments.each do |elf, assignment|
    next if elf_assignments[elf]
    
    assignment = startable.shift
    started[assignment] = now
    elf_assignments[elf] = assignment
  end
  now += 1
end

puts "Part 2: #{now}"
