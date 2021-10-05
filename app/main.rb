# Require all of Zif library
# require 'app/lib/zif/require.rb'

class Game
  attr_gtk

  def tick
    defaults
    calc
    input


    outputs.labels  << [640, 500, 'Velocities', 5, 1]
    outputs.labels  << [640, 450, "x: #{state.player.dx.floor}", 5, 1]
    outputs.labels  << [640, 400, "y: #{state.player.dy.floor}", 5, 1]
    outputs.labels  << [640, 500, 'Velocities', 5, 1]

    # outputs.sprites << { x: state.player.x,
    #                       y: state.player.y,
    #                       w: state.player.w,
    #                       h: state.player.h,
    #                       path: 'sprites/square/green.png' }
  end

  def defaults
    player.x ||= 100
    player.y ||= 100
    player.w ||= 40
    player.h ||= 40
    player.dx ||= 0
    player.dy ||= 0
    player.acceleration ||= 0.4
    player.max_speed ||= 20
    player.friction ||= 0.9
  end


  def player
    state.player ||= {}
  end

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
      state.player.dy += state.player.acceleration
      state.player.dy = state.player.dy.greater(-state.player.max_speed)
    elsif inputs.keyboard.down
      state.player.dy -= state.player.acceleration
      state.player.dy = state.player.dy.lesser(state.player.max_speed)
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



  def tick args
    $game ||= Game.new

    $game.args = args
    $game.tick
  end
