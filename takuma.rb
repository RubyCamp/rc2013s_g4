require 'dxruby'
require_relative './Score'

Window.width = 800
Window.height = 600

score = Score.new()

Window.loop do
	break if Input.keyPush?(K_ESCAPE)
	score.update_point(score.point)
	score.draw
end

