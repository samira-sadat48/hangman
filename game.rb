require 'yaml'

class Game
    attr_accessor :word, :word_clues, :guess_countdown, :letters_used 

    def initialize
        @word_clues = []
        @guess_countdown = 10
        @letters_used = []
    end

    def play
        @word = random_word
        @word.length.times { @word_clues.push("_")}

        while not_game_over?
            @guess = ask_player_for_letter
            #check if input is 'save'
            if @guess == 'save'
                save_game
                break
            end
            #if guess exists in word - replace all blanks
            if @word.include?(@guess)
                replace_blanks_with_letter
            else
                #if guess does not exist - decrement guess number
                @guess_countdown -= 1
            end
        end

        game_over
    end
    
    #################################################################################
    private

    def print_clue(clues)
        puts
        puts clues.join(' ')
        puts
    end

    def random_word
        file = File.open("5desk.txt")
        dictionary = file.readlines.map(&:chomp)
        line = rand(dictionary.size)
        dictionary[line]
    end

    def ask_player_for_letter
        guess = ""
        loop do
            print_clue(@word_clues)
            puts "You have #{@guess_countdown} incorrect guesses left."
            puts "Guess a letter: "
            guess = gets.chomp
            break if !@letters_used.include?(guess)
            puts "You have used #{guess} before. Try again."
        end
        @letters_used.push(guess)
        guess
    end

    def replace_blanks_with_letter
        @word_clues.each_with_index do |letter,index|
            #if match - change blank to guess
            if @guess == @word[index]
                @word_clues[index] = @guess
            end
        end
    end

    def not_game_over?
        @guess_countdown > 0  && (@word_clues.include? '_')
    end

    def game_over
        if @guess == "save"
            puts "You have saved your game to the file output/#{@filename}."
        elsif !@word_clues.include? '_'
            puts "You win! The answer is {#@word}."
        else
            puts "You lose! The answer is {#@word}."
        end
    end

    def save_game
        Dir.mkdir 'output' unless Dir.exist? 'output'
        puts "Enter a filename. Do not include extension."
        @filename = gets.chomp + ".yaml"
        File.open("output/#{@filename}", 'w') { |file| file.write convert_to_yaml }
    end

    def convert_to_yaml
        YAML.dump(
            'word' => @word,
            'word_clues' => @word_clues,
            'guess_countdown' => @guess_countdown,
            'letters_used' => @letters_used
        )
    end
end