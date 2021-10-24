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
    @paddle_1 = Paddle.new(100, 300, 20, 100, "wasd")
    @paddle_2 = Paddle.new(1150, 300, 20, 100, "arrows")
    @player_1_score = 0
    @player_2_score = 0
    @balls = [Ball.new(640, 360, 10, 10)]
    state.game_modes = { serve: true,
      blinky_ball: false,
      paused: false,
      bigball: false,
      bouncy_walls: false,
    }
  end

  def defaults
    state.game_modes ||= { serve: true,
      blinky_ball: false,
      paused: false,
      bigball: false,
      bouncy_walls: false,
    }
  end

  def tick
    defaults
    input
    labels

    @paddle_1.tick(args)
    @paddle_2.tick(args)
    @balls.each do |ball|
      ball.tick(args)
    end

    calc_collision(args)

    # Alternative approach for updating objects
    # outputs.solids << @paddle_1.tick(args)
    # outputs.solids << @paddle_2.tick(args)
  end

  def calc_collision(args)
    @balls.each do |ball|
      if @paddle_1.rect.intersect_rect?(ball.collision_rect) || @paddle_2.rect.intersect_rect?(ball.collision_rect)
        args.outputs.sounds << "sounds/paddle_hit.wav"
        ball.dx +=  (ball.dx.pos? ? 1 : -1) unless (ball.dx.abs() > 50 )
        ball.dx *= -1
      end
    end


    collide_walls
  end

  def input

    if state.game_modes[:serve] == true & inputs.keyboard.space
      state.game_modes[:serve] = false
    end

    if inputs.keyboard.escape
      @balls.each { |ball| ball.reset }
      state.game_modes[:serve] = true
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

    if inputs.keyboard.key_down.m
      big_ball_mode
    end

    if inputs.keyboard.key_down.n
      @balls.push(Ball.new(640, 360, 10, 10))
      state.game_modes[:multi_ball] = true
    end

    if inputs.keyboard.key_down.o
      state.game_modes[:bouncy_walls] = !state.game_modes[:bouncy_walls]
    end
  end

  def labels
    outputs.labels  << [100, 700, "Score: #{@player_1_score}", 5, 1]
    outputs.labels  << [1150, 700, "Score: #{@player_2_score}", 5, 1]


    # TODO: improve game_modes so it's not recalculated every tick.
    mode_y = 600
    state.game_modes.select {|k, v| v}.keys.each {|mode_name|
      outputs.labels  << [640, mode_y, mode_name, 2, 1]
      mode_y -= 30
    }

    if state.game_modes[:debug]
      outputs.labels  << [640, 150, "x: #{@balls[0].x}   dx: #{@balls[0].dx}", 5, 1]
      outputs.labels  << [640, 100, "y: #{@balls[0].y}   dy: #{@balls[0].dy}", 5, 1]
    end
  end


  def up_close_mode
    @paddle_1 = Paddle.new(400, 300, 20, 100, "wasd")
    @paddle_2 = Paddle.new(950, 300, 20, 100, "arrows")
  end

  def big_ball_mode
    state.game_modes[:big_ball] = true
    next_small_ball = @balls.find { |ball| ball.w != 100}
    if next_small_ball
      next_small_ball.w = 100
      next_small_ball.h = 100
    else
      @balls.each do |ball|
        ball.w = 10
        ball.h = 10
      end
      state.game_modes[:big_ball] = false
    end

  end

  def collide_walls
    @balls.each do |ball|
      if ball.y >= (720 - ball.h) || ball.y <= 0
        ball.dy *= -1
        outputs.sounds << "sounds/wall_hit.wav"
      end

    # goal collision
    if ball.x >= 1280 || ball.x <= 0
        outputs.sounds << "sounds/score2.wav"

        if !state.game_modes[:bouncy_walls]
          if ball.x >= 1280
            @player_1_score += 1
          else
            @player_2_score += 1
          end
          ball.reset
          state.game_modes[:serve] = true unless @balls.count > 1
        else
          # owngoal mode
          # deathball mode
          if ball.x >= 1280
            @player_2_score += 1
          else
            @player_1_score += 1
          end

          ball.dx *= -1
          ball.dx +=  (ball.dx.pos? ? 1 : -1) unless (ball.dx.abs() > 35)

        end
      end
    end
  end

end
