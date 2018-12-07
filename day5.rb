ingredients = File.read('day5.txt')
#ingredients = "dabAcCaCBAcCcaDA".split('')


def react(input)
    i = 0
    chars = input.split('')
    while i < chars.length - 1 do
        if chars[i] != chars[i+1] && chars[i].upcase == chars[i+1].upcase
            chars.delete_at(i+1)
            chars.delete_at(i)
            i -= 1
        else
            i += 1
        end
    end
    
    chars.join('')
end

rxn = react(ingredients)
puts "Part 1: #{rxn.length}"


rxns = ('a' .. 'z').each_with_object({}) do |c, h|
    h[c] = react(ingredients.gsub(/#{c}/i, '')).length
end
puts "Part 2: #{rxns.min_by{|k,v| v}}"


