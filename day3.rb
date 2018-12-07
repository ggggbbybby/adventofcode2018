claims = File.read('main.txt').split("\n")
#claims = ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]

class Claim
  REGEX = /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
  def self.parse(str)
    index, left, top, cols, rows = REGEX.match(str)[1..5].map(&:to_i)
    new(index, left, top, cols, rows)
  end

  attr_accessor :index, :left, :top, :cols, :rows
  def initialize(index, left, top, cols, rows)
    @index = index
    @left = left
    @top = top
    @cols = cols
    @rows = rows
  end

  def to_s
    "#{super}(##{index} @ #{left},#{top}: #{cols}x#{rows})"
  end

  def top_left
    [left, top]
  end

  def top_right
    [left + cols, top]
  end

  def bottom_right
    [left + cols, top + rows]
  end

  def bottom_left
    [left, top + rows]
  end
end

claims = claims.map { |c| Claim.parse(c) }
class ClaimMap
  attr_reader :data, :width, :height
  def initialize
    @data = Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = [] } }
    @width = 0
    @height = 0
  end

  def add_claim(claim)
    (claim.top ... claim.top + claim.rows).each do |row|
      (claim.left ... claim.left + claim.cols).each do |col|
        #puts "Claiming (#{row}, #{col}) for #{claim.index}"
        data[row][col] << claim.index
      end
    end
  end

  def conflicts
    result = []
    data.each do |row, cols|
      cols.each do |col, clams|
        result << [row, col, clams] if clams.count > 1
      end
    end

    result
  end
end

claim_map = ClaimMap.new
claims.each { |claim| claim_map.add_claim(claim) }

count = 0
claim_map.data.each do |row, cols|
  cols.each do |idx, col|
    count += 1 if col.count > 1
  end
end
puts "YOUSUNKMYBATTLESHIP"
puts "Part 1 Count: #{count}"

conflict_ids = []
claim_map.conflicts.each do |row, col, clams|
  conflict_ids += clams
  conflict_ids = conflict_ids.uniq
end
puts "Uncontested Claim: #{claims.map(&:index) - conflict_ids}"
