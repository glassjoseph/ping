class Paddle
  attr_accessor :x, :y, :w, :h, :control_scheme

  def initialize(x, y, w=10, h=100, control_scheme)
    @x = x
    @y = y
    @w = w
    @h = h
    @control_scheme = control_scheme
  end



  def update(args)
    if @control_scheme == "arrows"
      if args.inputs.keyboard.key_held.up
        go_up
      elsif args.inputs.keyboard.key_held.down
        go_down
      end
    end
    if @control_scheme == "wasd"
      if args.inputs.keyboard.key_held.w
        go_up
      elsif args.inputs.keyboard.key_held.s
        go_down
      end
    end
  end

  def go_up
     @y = (@y + 10).lesser(720 - @h)
  end

  def go_down
    @y = (@y - 10).greater(0)
  end

  def rect
    [@x, @y, @w, @h]
  end

  def tick(args)
    update(args)
    args.outputs.solids << [@x, @y, @w, @h]
  end
end