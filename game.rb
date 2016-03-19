require 'gosu'
#require_relative './z_order'

require_relative 'hang_man'
require_relative 'hangman_view'
require_relative 'random_word'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Hangman :P"

    #@background_image = Gosu::Image.new("media/space.png", :tileable => true)

    #@player = Player.new
    #@player.warp(320, 240)

    #@star_anim = Gosu::Image::load_tiles("media/star.png", 25, 25)
    #@stars = Array.new

    random_word = RandomWord.new('words.txt').get_word
    #@hangman = HangMan.new(random_word)
    @hangman = HangMan.new("hang")
    @progress = Gosu::Font.new(20)
    @tried_letters = Gosu::Font.new(20)
    @remaining_turns = Gosu::Font.new(20)
    @game_message = Gosu::Font.new(20)

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
    #@background_image.draw(0, 0, ZOrder::Background)
    @progress.draw(@hangman.word_progress, 10, 10, 1, 1.0, 1.0, 0xff_ffff00)
    # could probs exclude letters that were correct
    @tried_letters.draw("Tried letters: #{@hangman.tried_letters.join(',')}", 10, 50, 1, 1.0, 1.0, 0xff_ffff00)
    @game_message.draw(@message, 10, 200, 1, 1.0, 1.0, 0xff_ffff00)
    @progress.draw("Remaining turns #{@hangman.remaining_turns}", 10, 100, 1, 1.0, 1.0, 0xff_ffff00)
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

