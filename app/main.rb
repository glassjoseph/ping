# Require all of Zif library
# require 'app/lib/zif/require.rb'


require 'app/paddle.rb'
require 'app/ball.rb'
# require 'app/ping.rb'
require 'app/tick.rb'


class Ping
  attr_gtk

  def initialize
    @paddle_1 = Paddle.new(50, 50, 20, 100)
    @paddle_2 = Paddle.new(1200, 50, 20, 100)
    @ball = Ball.new(640, 360, 10, 10)
  end

  def tick
    defaults
    calc
    input


    outputs.labels  << [640, 700, 'Velocities', 5, 1]
    outputs.labels  << [640, 650, "x: #{state.player.dx.floor}", 5, 1]
    outputs.labels  << [640, 600, "y: #{state.player.dy.floor}", 5, 1]
    # outputs.labels  << [640, 460, 'Go to docs/docs.html and read it!', 5, 1]
    # outputs.labels  << [640, 420, 'Join the Discord! http://discord.dragonruby.org', 5, 1]
    # outputs.sprites << [576, 280, 128, 101, 'dragonruby.png']

    outputs.labels  << [640, 150, 'This world has been connected.', 5, 1]
    outputs.labels  << [640, 100, 'Tied to the darkness...', 5, 1]


    outputs.sprites << { x: state.player.x,
                          y: state.player.y,
                          w: state.player.w,
                          h: state.player.h,
                          path: 'sprites/square/green.png' }






    # outputs.solids << @paddle_1.tick(args)
    # outputs.solids << @paddle_2.tick(args)

    @paddle_1.tick(args)
    @paddle_2.tick(args)
    @ball.tick(args)
    # @ball.x = 500
    # @ball.y = 500

    # outputs.solids << @ball.tick(args)


    args.gtk.log_level = :off
  end

  def defaults
    player.x ||= 100
    player.y ||= 100
    player.w ||= 40
    player.h ||= 40
    player.dx ||= 0
    player.dy ||= 0

    # Slow acceleration
    # player.acceleration ||= 0.4
    # player.max_speed ||= 20
    # player.friction ||= 0.9

    # Instant acceleration
    player.acceleration ||= 10
    player.max_speed ||= 10
    player.friction ||= 0.1

    #



  end


  def player
    state.player ||= {}
  end

  # def paddle
  #   state.paddle ||= Paddle.new(50, 50, 20, 100)
  # end

  def input
    if inputs.keyboard.left
      state.player.dx -= state.player.acceleration
      state.player.dx = state.player.dx.greater(-state.player.max_speed)
    elsif inputs.keyboard.right
      state.player.dx += state.player.acceleration
      state.player.dx = state.player.dx.lesser(state.player.max_speed)
    else
      # state.player.dx *= state.player.friction
      if (-1..1).include?(state.player.dx) # => true
      # if (-0.05..0.05).incude?(state.player.dx)
        state.player.dx = 0
      else
        state.player.dx = (state.player.dx  * state.player.friction)
      end
    end

    if inputs.keyboard.up
      state.player.dy -= state.player.acceleration
      state.player.dy = state.player.dy.greater(state.player.max_speed)
    elsif inputs.keyboard.down
      state.player.dy += state.player.acceleration
      state.player.dy = state.player.dy.lesser(-state.player.max_speed)
    else
      # state.player.dy *= state.player.friction
      if (-1..1).include?(state.player.dy)
        state.player.dy = 0
      else
        state.player.dy = (state.player.dy  * state.player.friction)
      end
    end

    # if no buttons, decrease velocity



  end

  def calc
    state.player.x += state.player.dx
    state.player.y += state.player.dy
  end



end
