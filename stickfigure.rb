class Stickfigure
  attr_reader :x, :y

  def initialize(x, y, window)
    @x = x
    @y = y
    @stickfigure = Gosu::Image.new("media/stickfigure288px.png")
    @window = window
  end

  def draw
    @stickfigure.draw(x, y, 2)
  end

  def move_up(y)
    @y -= y
  end

  def width
    @stickfigure.width
  end

  def height
    @stickfigure.height
  end
end
