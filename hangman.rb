require_relative 'game'

file = File.open("5desk.txt")
dictionary = file.readlines.map(&:chomp)

#randomly select a word from dictionary
#random line in array
line = rand(dictionary.size)
word = dictionary[line]

game = Game.new(word)
game.play