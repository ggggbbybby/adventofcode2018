input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
input = File.read('day8.txt')
input = input.split(" ").map(&:to_i)

def parse(tree, nodes)
  children_count = tree.shift
  metadata_count = tree.shift
  
  metadata = 0
  value = 0

  children = []
  children_count.times { child_nodes = parse(tree, nodes) ; children << child_nodes.last}
 
  metadata_count.times do |i|
    mdata_value = tree.shift
    metadata += mdata_value
    if children_count == 0
      value += mdata_value
    else
      child_mdata = children[mdata_value - 1]&.last || 0
      value += child_mdata
    end
  end
  
  
  puts "Adding Node: #{[children_count, metadata_count, metadata, value].inspect}"
  nodes << [children_count, metadata_count, metadata, value]

  return nodes
end


nodes = parse(input, [])
metadata_sum = nodes.map { |n| n[2] }.inject(0) { |sum, i| i + sum}
puts "Part 1: #{metadata_sum}"
puts "Part 2: #{nodes.last.last}"
