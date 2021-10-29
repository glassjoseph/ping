class Ball
  attr_accessor :x, :y, :w, :h, :dx, :dy

  def initialize(x=640, y=360, w=10, h=10)
    @x = x
    @y = y
    @w = w
    @h = h

    BASE_SPEED = 5

    # @dx = (rand(50) + 30).randomize(:sign) #deathball
    @dx = (rand(BASE_SPEED) + 4).randomize(:sign)
    @dy = (rand(BASE_SPEED) + 4).randomize(:sign)
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
  end

  def collision_rect
    # expand collision rect ahead to detect next frame
    if @dx.positive?
      [@x, @y, @w + @dx, @h]
    else
      # shift ball collision detection to left
      [@x + @dx, @y, @w + @dx.abs(), @h]
    end
  end

  def tick(args)
    update unless args.state.game_modes[:serve] || args.state.game_modes[:paused]

    if args.state.game_modes[:blinky_ball]
      return if (args.state.tick_count % 100 < 20)
    end

    (args.outputs.solids << [@x, @y, @w, @h])
  end

end
