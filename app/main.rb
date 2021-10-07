# Require all of Zif library
# require 'app/lib/zif/require.rb'
require 'app/paddle.rb'
require 'app/ping.rb'




  def tick args
    $game ||= Ping.new

    $game.args = args
    $game.tick
  end
