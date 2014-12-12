require 'psych'

filename = "weapons.yml"
hash = Psych.load_file(filename);
File.open("out.txt", "w") do |f|
  hash.each_pair do |k, v|
    f.puts k
  end
end

