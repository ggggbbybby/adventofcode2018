input = <<TXT
[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
TXT

input = File.read('day3.txt')
input = input.split("\n").sort

class LogEntry
  def self.from_line(line)
    day, minute = /\d+-\d+-(\d\d) \d+:(\d\d)/.match(line)[1..2]
    new(day: day, minute: minute)
  end

  attr_accessor :day, :minute
  def initialize(day:, minute:)
    @day = day
    @minute = minute
  end
end

data = {}
current_guard = nil
sleep_timer = nil
current_state = :awake

input.each do |line|
  log = LogEntry.from_line(line)
  if line =~ /Guard \#(\d+) begins shift/
    current_guard = $1
    data[current_guard] ||= Hash.new { |h,k| h[k] = [] }
  elsif line =~ /falls asleep/
    if current_state == :awake
      current_state = :asleep
      sleep_timer = log.minute
    else
      puts "Guard can't fall asleep from sleep"
      puts line
      break
    end
  elsif line =~ /wakes up/
    if current_state == :asleep
      current_state = :awake
      sleep_minutes = (sleep_timer ... log.minute)
      data[current_guard][log.day] << sleep_minutes
      sleep_timer = nil
    else
      puts "Guard can't wake up when awake"
      puts line
      break
    end
  else
    puts "Unparseable: #{line}"
    break
  end
end

leaderboard = []
data.each do |guard, guard_data|
  sleep_times = []
  guard_data.each do |day, minutes|
    minutes.each do |minute_range|
      minute_range.each { |minute| sleep_times << minute }
    end
  end

  counts = sleep_times.each_with_object(Hash.new(0)) do |minute, result| 
    result[minute] += 1
  end

  minute, times = counts.max_by { |k, v| v }
  puts "Guard #{guard} slept for #{sleep_times.count} minutes"
  puts "Most Frequent Sleep Time: #{minute} (#{times} times)"
  leaderboard << [guard, sleep_times.count, minute, times || 0]
end

guard, count, minute, times = leaderboard.max_by { |g, c, m, t| c }
puts "Sleepiest Guard was ##{guard} for #{count}. Slept most at minute #{minute}, #{times} times"
puts "Part 1: #{guard} * #{minute} = #{guard.to_i * minute.to_i}"

guard, count, minute, times = leaderboard.max_by { |g, c, m, t| t }
puts "Most Consistent Guard was ##{guard} for #{count}. Slept most at minute #{minute}, #{times} times"
puts "Part 2: #{guard} * #{minute} = #{guard.to_i * minute.to_i}"
