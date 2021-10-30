class Ping
  attr_gtk

  def initialize
    setup
  end

  def setup
    green = [10, 187, 10]
    blue = [0, 118, 189, 200]

    @paddle_1 ||= Paddle.new(100, 300, 20, 100, "wasd", blue)
    @paddle_2 ||= Paddle.new(1150, 300, 20, 100, "arrows", green)
    @paddles ||= [@paddle_1, @paddle_2]
    @player_1_score ||= 0
    @player_2_score ||= 0

    @balls ||= [Ball.new(640, 360, 10, 10)]
    $gtk.args.state.game_modes ||= { serve: true,
      paused: false,
      mega_ball: false,
      blinky_ball: false,
      up_close_and_personal: false,
      bouncy_walls: false,
      free_range: false,
      multi_ball: false,
      "co-op": false
    }
  end

  def tick
    input
    labels
    highlight_goals

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
      @paddles.each do |paddle|
        if paddle.rect.intersect_rect?(ball.collision_rect)
          # reposition ball to near side of paddle on collision
          ball_offset = 10.greater(ball.w/2) # ball_width for small, ball midpoint for megaballs
          if (ball.x + ball.w) <= (paddle.x + ball_offset)
            ball.x = paddle.x - ball.w - 10
          else
            ball.x = paddle.x + paddle.w + 10
          end

          args.outputs.sounds << "sounds/paddle_hit.wav"
          ball.dx +=  (ball.dx.pos? ? 1 : -1) unless (ball.dx.abs() > 30 )
          ball.dx *= -1
        end
      end
    end

    collide_walls
  end

  def input
    if state.game_modes[:serve] == true & inputs.keyboard.space
      state.game_modes[:serve] = false
    end

    if inputs.keyboard.key_down.escape
      @balls.each { |ball| ball.reset }
      state.game_modes[:serve] = true
      setup
    end

    if inputs.keyboard.key_down.p || inputs.keyboard.key_down.q
      state.game_modes[:paused] = !state.game_modes[:paused]
    end

    if inputs.keyboard.key_down.m || inputs.keyboard.key_down.one
      mega_ball_mode
    end

    if inputs.keyboard.key_down.i || inputs.keyboard.key_down.two
      state.game_modes[:blinky_ball] = !state.game_modes[:blinky_ball]
    end

    if inputs.keyboard.key_down.x || inputs.keyboard.key_down.three
      state.game_modes[:up_close_and_personal] = !state.game_modes[:up_close_and_personal]

      if state.game_modes[:up_close_and_personal]
        @paddle_1.x = 440
        @paddle_2.x = 840
      else
        @paddle_1.x = 100
        @paddle_2.x = 1150
      end
    end

    if inputs.keyboard.key_down.b || inputs.keyboard.key_down.four
      state.game_modes[:bouncy_walls] = !state.game_modes[:bouncy_walls]
    end

    if inputs.keyboard.key_down.f || inputs.keyboard.key_down.five
      state.game_modes[:free_range] = !state.game_modes[:free_range]
    end


    if inputs.keyboard.key_down.y || inputs.keyboard.key_down.six
      @balls.push(Ball.new(640, 360, 10, 10))
      state.game_modes[:multi_ball] = true
    end

    if inputs.keyboard.key_down.u || inputs.keyboard.key_down.seven
      if @balls.count > 1
        @balls.pop()
      else
        state.game_modes[:multi_ball] = false
      end
    end


    if inputs.keyboard.key_down.c || inputs.keyboard.key_down.eight
      if !state.game_modes[:"co-op"]
        state.game_modes[:bouncy_walls] = true
        state.game_modes[:"co-op"] = true
      else
        state.game_modes[:"co-op"] = false
      end
    end
  end

  def labels
    outputs.labels  << [100, 700, "Score: #{@player_1_score}", 5, 1] unless state.game_modes[:"co-op"]
    outputs.labels  << [1150, 700, "Score: #{@player_2_score}", 5, 1]

    # TODO: improve game_modes so it's not recalculated every tick.
    mode_label_y = 700
    state.game_modes.as_hash.select {|k, v| v}.keys.each {|mode_name|
      outputs.labels  << [640, mode_label_y, mode_name, 2, 1]
      mode_label_y -= 30
    }

    if state.game_modes[:debug]
      outputs.labels  << [640, 150, "x: #{@balls[0].x}   dx: #{@balls[0].dx}", 5, 1]
      outputs.labels  << [640, 100, "y: #{@balls[0].y}   dy: #{@balls[0].dy}", 5, 1]
    end
  end

  def highlight_goals
    green = [27, 225, 27]
    green = [10, 187, 10]
    blue = [0, 118, 189, 200]
    if state.game_modes[:"co-op"]
      outputs.solids << [0, 0, 10, 720, 255, 0, 0, 200]
      outputs.solids << [1270, 0, 10, 720, 0, 28, 255, 99, 200]
    elsif state.game_modes[:bouncy_walls]
      outputs.solids << [1270, 0, 10, 720, green]
      outputs.solids << [0, 0, 10, 720, blue]

    else
      outputs.solids << [1270, 0, 10, 720, blue]
      outputs.solids << [0, 0, 10, 720, green]
    end
  end

  def mega_ball_mode
    state.game_modes[:mega_ball] = true
    next_small_ball = @balls.find { |ball| ball.w != 100}
    if next_small_ball
      next_small_ball.w = 100
      next_small_ball.h = 100
    else
      @balls.each do |ball|
        ball.w = 10
        ball.h = 10
      end
      state.game_modes[:mega_ball] = false
    end
  end

  def collide_walls
    @balls.each do |ball|
      if ball.y >= (720 - ball.h) || ball.y <= 0
        ball.dy *= -1
        outputs.sounds << "sounds/wall_hit.wav"
      end

    # goal collision
    if ball.x >= (1280 - ball.w) || ball.x <= 0
      collide_sound = "sounds/score2.wav"
      # standard goal
        if !state.game_modes[:bouncy_walls]
          if ball.x >= (1280 - ball.w)
            @player_1_score += 1
          else
            @player_2_score += 1
          end
          ball.reset
          state.game_modes[:serve] = true unless @balls.count > 1
        else
          # owngoal mode
          if ball.x >= (1280 - ball.w)
            @player_2_score += 1
          else
            @player_1_score += 1
            if state.game_modes[:"co-op"]
              @player_2_score -= 2
              collide_sound = "sounds/hit.wav"
            end
          end

          ball.dx *= -1
          ball.dx +=  (ball.dx.pos? ? 1 : -1) unless (ball.dx.abs() > 30)
        end

        outputs.sounds << collide_sound
      end
    end
  end

end
