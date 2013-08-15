#inu class
#2013/08/10 9:45 線路を辿るとこまで実装
#2013/08/10 16:15 いぬの状態（歩・喜・悲）まで実装
require_relative 'const'
#島根犬クラス
class Inu < Sprite
	attr_accessor :status, :count
	include Const
	#初期化
	def initialize( x, y, file )
		#####移動に関する変数#####

		#いぬの速さ
		@speed = 0.3

		#音
		@sound_item = Sound.new("#{APP_ROOT}/sounds/se_itemget.wav")

		@sound_gameover = Sound.new("#{APP_ROOT}/sounds/se_gameover.wav")

		#移動方向（とりあえず最初は↓に）
		@direction = RIGHT

		#線路
		@senro = Senro.new

		#マップの1セルの大きさ
		@c_size = 40

		#マップの分割数
		@m_size = 15

		#####ここまで#####


		#####喜・悲の状態#####
		@count = 0

		@status = WALK

		#####ここまで#####

		@img = Array.new(3)

		@img[WALK] = Image.load("#{APP_ROOT}/images/chara/dog1.png")
		@img[GLAD] = Image.load("#{APP_ROOT}/images/chara/dog2.png")
		@img[SAD] = Image.load("#{APP_ROOT}/images/chara/dog3.png")

		@img[WALK].setColorKey([255, 255, 255])
		@img[GLAD].setColorKey([255, 255, 255])
		@img[SAD].setColorKey([255, 255, 255])
		super
	end

	#犬の移動
	def update( map )

		#####移動に関する処理#####
		#1マスごとに移動方向を切り替える

		if self.x % @c_size < @speed && self.y % @c_size < @speed && @status == WALK
			#線路から移動すべき方向を取得
			@direction = @senro.next_direction( map[ ( self.y / @c_size ).to_i ][ ( self.x / @c_size ).to_i ], @direction )
		end

		#移動
		if @status == WALK
			case @direction
			when TOP
				self.y -= @speed
			when BOTTOM
				self.y += @speed
			when LEFT
				self.x -= @speed
			when RIGHT
				self.x += @speed
			else
				@status = SAD
			end
		end

		#####ここまで#####

		if @status == GLAD
			if @count == 0
				@sound_item.play
			end
			@count += 1
			if @count > 60
				@status = WALK
				@count = 0
			end
		end

		if @status == SAD
			if @count == 0
				if ( self.x / @c_size ).to_i != 14 && (( self.y / @c_size ).to_i != 4 || ( self.y / @c_size ).to_i != 9 || ( self.x / @c_size ).to_i != 14)
					@sound_gameover.play
				end
			end
			@count += 1
		end
	end

	#いぬの場所(マップ配列のインデックス)を返すメソッド
	def getPos
		return (self.x/@c_size).to_i, (self.y/@c_size).to_i
	end

	def draw
		Window.draw(self.x,self.y,@img[@status])
	end

end