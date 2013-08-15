class Score
	attr_accessor :point, :x, :y, :font

	def initialize()
		@x = 610	#x座標
		@y = 100	#y座標
		@point = 0	#ポイント
		@font = Font.new(32)
	end

	# スコアの更新
	def updatePoint(num)
		@point += num
	end

	# スコアの描画
	def draw
		 Window.drawFont(@x, @y, "SCORE:#{@point}", @font)
	end

end