#ids = %w(abcdef bababc abbcde abcccd aabcdd abcdee ababab)
ids = File.read('day2.txt').split("\n")


twos = 0
threes = 0

ids.each do |id|
  count = id.split('').each_with_object(Hash.new(0)) { |i, h| h[i] += 1 }
  twos += 1 if count.any? { |k, v| v == 2 }
  threes += 1 if count.any? { |k, v| v == 3 }
end

puts "Part 1: #{twos} * #{threes} = #{twos * threes}"

#ids = %w(abcde fghij klmno pqrst fguij axcye wvxyz)
pairs = []

ids.each_with_index do |id, i|
  j = i + 1
  while j < ids.count do
    pairs << [id, ids[j]]
    j += 1
  end 
end

id1, id2 = pairs.detect do |p1, p2|
  zips = p1.split('').zip(p2.split(''))
  zips.count {|z1, z2| z1 != z2 } < 2

end

puts id1
puts id2
id1.split('').zip(id2.split('')).each { |a, b| print a == b ? " " : "^"}