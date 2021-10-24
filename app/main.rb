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
    # $gtk.args.state.game_mode = 'intro'
    # $gtk.args.state.game_modes = ["intro", "pause", "play" ]

  end

  # convenience method for tweaking paddles during dev. Consider moving to init on publish.
  def setup
    # @paddle_1 = Paddle.new(50, 50, 20, 100)
    # @paddle_2 = Paddle.new(1200, 50, 20, 100)
    @paddle_1 = Paddle.new(100, 300, 20, 100, "wasd")
    @paddle_2 = Paddle.new(1150, 300, 20, 100, "arrows")
    @player_1_score = 0
    @player_2_score = 0
    @ball = Ball.new(640, 360, 10, 10)

    # modes
    # owngoal: bouncy walls and own-goal
    #
    # tag: bouncy walls, one paddle, scoring on paddle/ball collision

  end

  def defaults
    state.game_modes ||= { blinky_ball: false,
      paused: false,
      bigball: false,
      bouncy_walls: false,
    }



  end

  def tick
    defaults
    input
    outputs.labels  << [100, 700, "Score: #{@player_1_score}", 5, 1]
    outputs.labels  << [1150, 700, "Score: #{@player_2_score}", 5, 1]
    # outputs.labels  << [640, 600, "#{state.game_modes}", 2, 1]
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

    if @paddle_1.rect.intersect_rect?(@ball.collision_rect) || @paddle_2.rect.intersect_rect?(@ball.collision_rect)
      args.outputs.sounds << "sounds/paddle_hit.wav"

      puts "BOOOOOOOOOONK"
      @ball.dx +=  (@ball.dx.pos? ? 1 : -1) unless (@ball.dx.abs() > 50 )
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

    if inputs.keyboard.key_down.p || inputs.keyboard.key_down.q
      state.game_modes[:paused] = !state.game_modes[:paused]
    end

    if inputs.keyboard.key_down.b
      state.game_modes[:blinky_ball] = !state.game_modes[:blinky_ball]
    end

    if inputs.keyboard.key_down.n
      big_ball_mode
    end

    if inputs.keyboard.key_down.o
      state.game_modes[:bouncy_walls] = !state.game_modes[:bouncy_walls]
    end


  end




  def up_close_mode
    @paddle_1 = Paddle.new(400, 300, 20, 100, "wasd")
    @paddle_2 = Paddle.new(950, 300, 20, 100, "arrows")
  end

  def big_ball_mode
    @ball.w = 100
    @ball.h = 100
  end

  def collide_walls
    if @ball.y >= (720 - @ball.h) || @ball.y <= 0
      @ball.dy *= -1
      outputs.sounds << "sounds/wall_hit.wav"
      puts 'bonk'
    end

   # goal collision
   if @ball.x >= 1280 || @ball.x <= 0

    puts state.game_modes
      outputs.sounds << "sounds/score2.wav"

      if !state.game_modes[:bouncy_walls]
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
