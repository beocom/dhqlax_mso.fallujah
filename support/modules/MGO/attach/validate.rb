require 'psych'

filename = "weapons.yml"

h = Hash.new(0)
File.open(filename) do |f|
  f.each_line do |line|
    words = line.scan(/\s*([^\s]+)\s*:/)
    words.each do |m|
      m.each do |v|
        h.store(v, h[v]+1)
      end
    end    
  end
end

cnt = 0
h.each_pair do |k, v|
  if v > 1
    puts "#{k} #{v}"
    cnt += 1
  end
end

puts "Found #{cnt} duplicates."