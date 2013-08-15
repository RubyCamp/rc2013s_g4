require_relative '../lib/score'
require_relative '../lib/map'
require_relative '../lib/inu'
require_relative '../lib/const'

include Const

module Window
  def self.drawLine(x1, y1, x2, y2, c, z = 0)
    pixel = Image.new(1, 1, c)
    sx = Math.sqrt(((x1 - x2)**2) + ((y1 - y2)**2))
    angle = Math.atan2(y2 - y1, x2 - x1) / Math::PI * 180
    Window.drawEx((x2 + x1) / 2, (y2 + y1) / 2, pixel,
                  :scalex=>sx, :scaley=>1,
                  :centerx=>0.5, :centery=>0.5,
                  :angle=>angle, :z=>z)
  end
end

# ゲーム本体シーンの管理用クラス
class Game
  ROW_PIECES  = 3 # 1行当たりのピース数
  # PIECE_COUNT = 6 # ピースの総数
  piece_count = 6

  # ゲームシーンの初期化
  def initialize
    # @@mode = "EASY"
		#マウスクリックに関する動作の初期化
    @pointer = Sprite.new(0, 0)
    @pointer.collision = [0, 0, 1]

    #音
    @bgm = Sound.new("#{APP_ROOT}/sounds/bgm_game.mid")
    @bgm.play

    if @@mode == "EASY"
        piece_count = 12
      elsif @@mode == "NORMAL"
        piece_count = 9
      elsif @@mode == "HARD"
        piece_count = 6
      end


    @hands = []
    piece_count.times do |i|
      @hands << Hand.new(i,self)
    end
		#scoreの初期化
    @score = Score.new()

		#TODO tefudaの初期化
    #charaの初期化
    @inu = Inu.new( 0, 0, "#{APP_ROOT}/images/chara/dog1.png" )
    #mapの初期化
    @mapdata = MapData.new

    #debug
    # @mapdata.map[1][1] = GOAL

    @bgimage = Util.load_image("#{APP_ROOT}images/shimanemap2.png")
    #手札の描画座標を更新
    Sprite.update(@hands)
  end

  # シーンの進行（1フレーム分）
  def play

    # pp @@mode

    # 左マウスボタンクリック時の挙動
    if Input.mousePush?(M_LBUTTON)
      # 現時点のマウス座標を取得し、ポインタオブジェクトの座標を更新
      @pointer.x = Input.mousePosX
      @pointer.y = Input.mousePosY
      # ポインタオブジェクトとピース群の当たり判定
      # ※ ポインタと衝突しているピースオブジェクトの#hitメソッドが呼ばれる
      Sprite.check(@pointer, @hands)
    end

    #終了処理
    cleared
    over

    #いぬの移動
    @inu.update(@mapdata.map)
    # if chara.state != GLAD
    #   chara.state = GLAD
    # end


    # TODO
    #背景画像
    # 背景画像の描画
    Window.draw(0,0,@bgimage)

      # map描画
      @mapdata.draw
      # item描画
      # inu描画
      @inu.draw
    Window.drawLine(599,0,599,600,[255,255,255])
    # Window.drawLine(100,100,200,200,[255,255,0])

    updateItem

    # ハンドオブジェクトの描画
    Sprite.draw(@hands)
    # スコアオブジェクトの描画
    @score.draw

  end

  # ピースがクリックされた際にコールバックしてくるメソッド
  # クリックされたハンドを判定し、選択されたものをマップに渡す。
  def hand_clicked(hand)
    if @mapdata.map[@mapdata.y_target][@mapdata.x_target] == GOAL
      return
    end

    give_number = hand.number
    idx = hand.pos
    #マップクラスに線路の番号(1~6)を渡す。
    @mapdata.railInsert(give_number)
 #デバッグ
 #   p [give_number, hand.pos]
    #新しい手札をドローする
    @hands[idx] = Hand.new(idx,self)
    Sprite.update(@hands)
  end

  # あるピースについて、移動可能なマス目があるかどうかを判定する
  def available_pos(pos)
  end

  # 指定された二次元座標のマス目が移動可能かどうかを判定
  def check_coord(x, y)
  end

  def  updateItem
    x, y = @inu.getPos
    if @mapdata.map_item[y][x] != 0
      @mapdata.itemDel(x, y) #アイテムの更新
      # SCORE更新
      @score.updatePoint(15)

      @inu.status = GLAD
    end
  end

  # クリア判定
  def cleared
    x, y = @inu.getPos
    if @mapdata.map[y][x] == GOAL
      pp @mapdata.map[y][x]
      case y
      when 4
        @score.updatePoint(100)
      when 9
        @score.updatePoint(200)
      when 14
        @score.updatePoint(300)
      end
      Ending.setScore(@score) #scoreオブジェクトをエンディングに渡す
      Director.change_scene(:ending)
    end
  end

  def over
    if @inu.status == SAD
      if @inu.count > 60
        @bgm.stop
        Over.setScore(@score) #scoreオブジェクトをエンディングに渡す
        Director.change_scene(:over)
      end
    end
  end

  def self.set_mode(mode)
    @@mode = mode
  end
end