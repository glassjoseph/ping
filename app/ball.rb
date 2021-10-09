class Ball
  attr_accessor :x, :y, :w, :h, :dx, :dy

  def initialize(x, y, w=100, h=100)
    @x = x
    @y = y
    @w = w
    @h = h

    # @dx = Math.rand(3)
    # @dy = Math.rand(3)

  end

  def update
    @x += @dx
    @y += @dy
  end

  def tick(args)
    # update
    args.outputs.solids << [@x, @y, @w, @h]
    # puts "X: #{x}, Y: #{y}"
    # args.outputs.solids << [10, 10, 10, 10]
  end

end
