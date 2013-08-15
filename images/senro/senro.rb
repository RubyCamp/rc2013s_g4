class Senro < Sprite
def initialize
@left = 1
@right = 2
@top = 3
@bottom = 4
end

def next_direction(kind, direction)

  if kind == 1 && direction == @right then return @right
	end
	if kind == 1 && direction == @left then return @left
	end
	if kind == 2 && direction == @bottom then return @bottom
	end
	if kind == 2 && direction == @top then return @top
	end
	if kind == 3 && direction == @bottom then return @left
	end
	if kind == 3 && direction == @right then return @top
	end
	if kind == 4 && direction == @right then return @bottom
	end
	if kind == 4 && direction == @top then return @left
	end
	if kind == 5 && direction == @top then return @right
	end
	 if kind == 5 && direction == @left then return @bottom
	end
	if kind == 6 && direction == @bottom then return @right
	end
	if kind == 6 && direction == @left then return @top
	end
end

end