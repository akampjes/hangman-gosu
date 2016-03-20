require 'gosu'

require_relative 'hang_man'
require_relative 'hangman_view'
require_relative 'random_word'
require_relative 'balloon'
require_relative 'stickfigure'

class GameWindow < Gosu::Window
  GAME_TURNS = 8

  def initialize
    super 1920, 1200
    self.caption = "Hangman :P"

    random_word = RandomWord.new('words.txt').get_word
    random_word = "hang"
    @hangman = HangMan.new("hang", turns: GAME_TURNS)

    @background_image = Gosu::Image.new("media/windows-xp-background.jpg")
    @stickfigure = Stickfigure.new(800, 600, self)
    @balloons = []

    @progress = Gosu::Font.new(50)
    @tried_letters = Gosu::Font.new(50)
    @remaining_turns = Gosu::Font.new(50)
    @game_message = Gosu::Font.new(50)

    @message = ""
  end

  def move_up
    @balloons.each { |balloon| balloon.move_up(10) }
    @stickfigure.move_up(10)
  end

  def update
    if @hangman.won?
      @message = "you win"
    elsif @hangman.lost?
      @message = "you lose"
      move_up
    end

    while @balloons.count < (GAME_TURNS - @hangman.remaining_turns)
      @balloons << Balloon.new(800 + (rand(300)), 300, self, @stickfigure)
    end
  end

  def draw
    @background_image.draw(0, 0, 0)

    @stickfigure.draw
    @balloons.each { |balloon| balloon.draw }

    @progress.draw(@hangman.word_progress, 10, 10, 2, 1.0, 1.0, 0xff_000000)
    # could probs exclude letters that were correct
    @tried_letters.draw("Tried letters: #{@hangman.tried_letters.join(',')}", 10, 100, 2, 1.0, 1.0, 0xff_000000)
    @game_message.draw(@message, 10, 200, 2, 1.0, 1.0, 0xff_000000)
    @progress.draw("Remaining turns #{@hangman.remaining_turns}", 10, 300, 2, 1.0, 1.0, 0xff_000000)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    else
      char = button_id_to_char(id)
      if char =~ /[[:alpha:]]/
        begin
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

