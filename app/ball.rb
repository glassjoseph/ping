class Ball
  attr_accessor :x, :y, :w, :h, :dx, :dy

  def initialize(x=640, y=360, w=100, h=100)
    @x = x
    @y = y
    @w = w
    @h = h

    @dx = (rand(5) + 4).randomize(:sign)
    @dy = (rand(5) + 4).randomize(:sign)

  end

  def reset
    @x = 640
    @y = 360
    @dx = (rand(5) + 4).randomize(:sign)
    @dy = (rand(5) + 4).randomize(:sign)
  end

  def update
    @x += @dx
    @y += @dy
    collide_walls
  end


  def collide_walls
    if @y >= 720 || @y <= 0
      @dy *= -1
      puts 'bonk'
    end
  end


  def tick(args)
    update
    args.outputs.solids << [@x, @y, @w, @h]
    # puts "X: #{x}, Y: #{y}"
    # args.outputs.solids << [10, 10, 10, 10]
  end

end
