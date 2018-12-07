coords = <<TXT
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
TXT
max_distance = 32

coords = File.read('day6.txt')
max_distance = 10000

coords = coords.split("\n").map { |row| row.split(", ").map(&:to_i) }

max_x = coords.max_by { |x, y| x }[0]
max_y = coords.max_by { |x, y| y }[1]

def manhattan(sx, sy, dx, dy)
  (sx - dx).abs + (sy - dy).abs
end

grid = Hash.new { |h,k| h[k] = {} }
minimums = Hash.new { |h,k| h[k] = {}}
close_enough = []

(0..max_x).each do |x|
  (0..max_y).each do |y|
    coords.each do |px, py|
      grid[x][y] ||= {}
      grid[x][y][[px, py]] = manhattan(px, py, x, y)
    end
    minimums[x][y] = grid[x][y].min_by { |p, distance| distance}
    close_enough << [x, y] if grid[x][y].values.sum < max_distance
  end
end

areas = Hash.new(0)
infinites = []
minimums.each do |x, ys|
  ys.each do |y, (point, distance)|
    if infinites.include?(point)
      areas[point] = 0
      next
    end
    infinites << point if x == 0 || y == 0 || x == max_x || y == max_y
    areas[point] += 1
  end
end

puts "Part 1: #{areas.max_by { |p, a| a }.inspect}"
puts "Part 2: #{close_enough.length}"
