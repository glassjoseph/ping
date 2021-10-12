class Paddle
  # attr_gtk
  attr_accessor :x, :y, :w, :h

  def initialize(x, y, w=10, h=100)
    @x = x
    @y = y
    @w = w
    @h = h
  end

  def update(args)
    if args.inputs.keyboard.up
      @y = (@y + 10).lesser(720 - @h)
    elsif args.inputs.keyboard.down
      @y = (@y - 10).greater(0)
    end
  end

  def rect
    [@x, @y, @w, @h]
  end

  def tick(args)
    update(args)
    args.outputs.solids << [@x, @y, @w, @h]
  end
end