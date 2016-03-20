class Balloon
  attr_reader :x, :y

  def initialize(x, y, window, stickfigure)
    @x = x
    @y = y
    @balloon = Gosu::Image.new("media/balloon.png")
    @window = window
    @stickfigure = stickfigure
  end

  def draw
    @balloon.draw(x, y, 2)
    @window.draw_line(x+@balloon.width/2,
                      y+@balloon.height,
                      0xff_000000,
                      @stickfigure.x+(@stickfigure.width/2),
                      @stickfigure.y+100,
                      0xff_000000,
                      1
                     )
  end

  def move_up(y)
    @y -= y
  end
end
