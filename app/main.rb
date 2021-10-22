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
    @player_1_score = 0
    @player_2_score = 0
    @ball = Ball.new(640, 360, 10, 10)

    #modes
    @game_mode = "intro"
    @bouncy_walls = false
  end


  def tick
    # defaults
    input
    outputs.labels  << [100, 700, "Score: #{@player_1_score}", 5, 1]
    outputs.labels  << [1150, 700, "Score: #{@player_2_score}", 5, 1]
    outputs.labels  << [640, 700, 'Velocities', 5, 1]
    outputs.labels  << [640, 150, "x: #{@ball.x}   dx: #{@ball.dx}", 5, 1]
    outputs.labels  << [640, 100, "y: #{@ball.y}   dy: #{@ball.dy}", 5, 1]


    # outputs.solids << @paddle_1.tick(args)
    # outputs.solids << @paddle_2.tick(args)

    @paddle_1.tick(args)
    @paddle_2.tick(args)
    @ball.tick(args)

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

    collide_walls
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

  def collide_walls
    if @ball.y >= 720 || @ball.y <= 0
      @ball.dy *= -1
      outputs.sounds << "sounds/wall_hit.wav"
      puts 'bonk'
    end

    # goal collision
    if @ball.x >= 1280 || @ball.x <= 0

      outputs.sounds << "sounds/score.wav"

      if !@bouncy_walls
        if @ball.x >= 1280
          @player_1_score += 1
        else
          @player_2_score += 1
        end
        @ball.reset
      else
        # owngoal mode
        # deathball mode
        if @ball.x >= 1280
          @player_2_score += 1
        else
          @player_1_score += 1
        end

        @ball.dx *= -1
        @ball.dx +=  (@ball.dx.pos? ? 1 : -1) unless (@ball.dx.abs() > 35)

        puts 'bonk score'
        # $gtk.args.outputs.sounds << "sounds/wall_hit.wav"
      end
    end
  end

end
