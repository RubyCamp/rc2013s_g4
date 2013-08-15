require_relative 'map'

class Hand < Sprite
	BASE_X = 640	# 手札描画位置のX座標オフセット
	BASE_Y = 350	# 手札描画位置のY座標オフセット


#初期化
	attr_accessor :number, :pos

	def initialize(pos, game)
		n = rand(6)
		@number = n+1
		@pos = pos
		@game = game

		self.image = Util.load_image("#{APP_ROOT}images/senro/senro#{@number}.png")
	end

#画面上の座標を更新
	def update
		#p @pos
	    self.x = BASE_X + (Util.pos_x(@pos) * self.image.width)
	    self.y = BASE_Y + (Util.pos_y(@pos) * self.image.height)
 	 end

  # マウスポインタ（非表示）との接触時に呼び出されるメソッド
	def hit(pointer)
    @game.hand_clicked(self)
  	end
 end