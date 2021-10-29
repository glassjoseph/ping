def tick args
  $game ||= Ping.new

  $game.args = args
  $game.tick
end
