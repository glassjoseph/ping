class Ball
  attr_accessor :x, :y, :w, :h, :dx, :dy

  def initialize(x=640, y=360, w=100, h=100)
    @x = x
    @y = y
    @w = w
    @h = h

    BASE_SPEED = 5

    # @dx = (rand(50) + 30).randomize(:sign) #deatball
    @dx = (rand(BASE_SPEED) + 4).randomize(:sign)
    @dy = (rand(BASE_SPEED) + 4).randomize(:sign)
    # @dy = 0

  end

  def reset
    @x = 640
    @y = 360
    @dx = (rand(BASE_SPEED) + 4).randomize(:sign)
    @dy = (rand(BASE_SPEED) + 4).randomize(:sign)
  end

  def update
    @x += @dx
    @y += @dy
    collide_walls
  end


  def collide_walls
    if @y >= 720 || @y <= 0
      @dy *= -1
      $gtk.args.outputs.sounds << "sounds/wall_hit.wav"
      puts 'bonk'
    end

    if @x >= 1280 || @x <= 0
      $gtk.args.outputs.sounds << "sounds/score.wav"
      # increment score
      reset

      # deathball mode
      if false
        @dx *= -1
        @dx +=  (@dx.pos? ? 1 : -1) unless (@dx.abs() > 35)
        puts 'bonk'
        $gtk.args.outputs.sounds << "sounds/wall_hit.wav"
      end
    end


  end

  def rect
    [@x, @y, @w, @h]
  end


  def tick(args)
    update
    args.outputs.solids << [@x, @y, @w, @h]
    # puts "X: #{x}, Y: #{y}"
    # args.outputs.solids << [10, 10, 10, 10]
  end

end
