class Paddle
  # attr_gtk
  attr_accessor :x, :y, :w, :h

  def initialize(x, y, w=10, h=100)
    @x = x
    @y = y
    @w = w
    @h = h
  end

  def calc_inputs(args)
    if args.inputs.keyboard.up
      @y += 10
    elsif args.inputs.keyboard.down
      @y -= 10
    end
  end

  def tick(args)
    calc_inputs(args)
    args.outputs.solids << [@x, @y, @w, @h]
  end
end