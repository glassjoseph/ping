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
    @paddle_1 = Paddle.new(50, 50, 20, 100)
    @paddle_2 = Paddle.new(1200, 50, 20, 100)
    @ball = Ball.new(640, 360, 10, 10)
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





    args.gtk.log_level = :off
  end

  def defaults
  end



  def input

    if inputs.keyboard.escape
      @ball.reset
      setup
    end

    # if no buttons, decrease velocity



  end


end
