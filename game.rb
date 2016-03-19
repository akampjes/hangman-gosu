require 'gosu'

require_relative 'hang_man'
require_relative 'hangman_view'
require_relative 'random_word'

class GameWindow < Gosu::Window
  GAME_TURNS = 8

  def initialize
    super 1920, 1200
    self.caption = "Hangman :P"

    random_word = RandomWord.new('words.txt').get_word
    random_word = "hang"
    @hangman = HangMan.new("hang", turns: GAME_TURNS)

    @background_image = Gosu::Image.new("media/windows-xp-background.jpg")
    @stickfigure = Gosu::Image.new("media/stickfigure288px.png")
    @balloons = []
    @balloon = Gosu::Image.new("media/balloon.png")

    @progress = Gosu::Font.new(50)
    @tried_letters = Gosu::Font.new(50)
    @remaining_turns = Gosu::Font.new(50)
    @game_message = Gosu::Font.new(50)

    @message = ""
  end

  def update
    if @hangman.won?
      @message = "you win"
    elsif @hangman.lost?
      @message = "you lose"
    end
  end

  def draw
    @background_image.draw(0, 0, 0)
    @stickfigure.draw(800, 600, 1)

    @balloon.draw(800, 300, 1)

    @progress.draw(@hangman.word_progress, 10, 10, 1, 1.0, 1.0, 0xff_000000)
    # could probs exclude letters that were correct
    @tried_letters.draw("Tried letters: #{@hangman.tried_letters.join(',')}", 10, 100, 1, 1.0, 1.0, 0xff_000000)
    @game_message.draw(@message, 10, 200, 1, 1.0, 1.0, 0xff_000000)
    @progress.draw("Remaining turns #{@hangman.remaining_turns}", 10, 300, 1, 1.0, 1.0, 0xff_000000)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    else
      char = button_id_to_char(id)
      puts char
      if char =~ /[[:alpha:]]/
        begin
          puts char
          @hangman.play_turn(char)
          @message = ""
        rescue HangMan::InvalidLetterError => e
          puts "Not a valid alphabetical Letter :("
        rescue HangMan::AlreadyUsedLetterError => e
          @message = "You've already tried that letter silly :P"
        end
      end
    end
  end
end

window = GameWindow.new
window.show

