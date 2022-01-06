require_relative 'game'

loop do
    Game.new.play
    puts "Play again? Yes(1) or no(2)?"
    again = gets.chomp.to_i
    break if again == 2
end

