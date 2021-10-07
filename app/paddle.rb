class Paddle
  attr_gtk
  attr_accessor :x, :y, :w, :h, :doofs

  def initialize(x, y, w=20, h=100)
    @x = x
    @y = y
    @w = w
    @h = h
  end

  def render
    return [x, y, w, h]
  end

end