# Require all of Zif library
# require 'app/lib/zif/require.rb'


require 'app/paddle.rb'
require 'app/ball.rb'
# require 'app/ping.rb'
require 'app/tick.rb'


class Ping
  attr_gtk

  def initialize
    setup
  end

  # convenience method for tweaking paddles during dev. Consider moving to init on publish.
  def setup
    # @paddle_1 = Paddle.new(50, 50, 20, 100)
    # @paddle_2 = Paddle.new(1200, 50, 20, 100)
    @paddle_1 = Paddle.new(100, 50, 20, 100)
    @paddle_2 = Paddle.new(1150, 50, 20, 100)
    @ball = Ball.new(640, 360, 10, 10)

    @game_state = "intro"
    @set = false
  end


  def tick
    # defaults
    input
    outputs.labels  << [640, 700, 'Velocities', 5, 1]
    outputs.labels  << [640, 150, "x: #{@ball.x}   dx: #{@ball.dx}", 5, 1]
    outputs.labels  << [640, 100, "y: #{@ball.y}   dy: #{@ball.dy}", 5, 1]


    # outputs.solids << @paddle_1.tick(args)
    # outputs.solids << @paddle_2.tick(args)

    @paddle_1.tick(args)
    @paddle_2.tick(args)
    @ball.tick(args)
    # @ball.x = 500
    # @ball.y = 500


    calc_collision(args)

    args.gtk.log_level = :off
  end

  def calc_collision(args)
    if @paddle_1.rect.intersect_rect?(@ball.rect) || @paddle_2.rect.intersect_rect?(@ball.rect)
      args.outputs.sounds << "sounds/paddle_hit.wav"

      puts "BOOOOOOOOOONK"
      @ball.dx +=  (@ball.dx.pos? ? 1 : -1) unless (@ball.dx.abs() > 35 )
      @ball.dx *= -1
    end
  end

  def input

    if inputs.keyboard.escape
      @ball.reset
      setup
    end

    if inputs.keyboard.c
      up_close_mode
    end

  end

  def up_close_mode
    @paddle_1 = Paddle.new(400, 50, 20, 100)
    @paddle_2 = Paddle.new(950, 50, 20, 100)
  end

end
