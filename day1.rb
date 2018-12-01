lines = File.read('day1.txt').split("\n")

adjustment = lines.inject(0) { |result, l| result + Integer(l)}
puts "Part 1: #{adjustment}"

seen = Hash.new(0)
result = 0
i = 0
mod = lines.count
while true do
  result += Integer(lines[i % mod])
  i += 1
  seen[result] += 1
  break if seen[result] > 1
end

puts "Part 2: #{result}"