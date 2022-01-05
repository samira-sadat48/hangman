file = File.open("5desk.txt")
dictionary = file.readlines.map(&:chomp)

puts dictionary