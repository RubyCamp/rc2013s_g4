=begin
クラス　   :MapDate    ・・・ マップ関係の処理を行うクラス
メソッド   :initialize ・・・ マップの初期化
        :railInsert ・・・ 線路の情報を貰い、線路の配置をする
        :mapDiso    ・・・ Mapを表示する
        :itemDel    ・・・　取得したアイテムデータを消去する
        :changeDirection ・・・　方向情報を更新する
=end

require 'dxruby'
require 'pp'
require_relative 'const'
require_relative '../images/senro/senro'
include Const

class MapData
  attr_accessor :map, :map_item, :item, :direction, :senro, :senro_img, :rail_position, :x_target, :y_target, :item_num
  def initialize

    #線路を配置したときのSE情報を保存する
    @sound_senro = Sound.new("#{APP_ROOT}/sounds/se_senrohaiti.wav")

    #線路用とアイテム用マップの二次元配列の作成
    @map       = Array.new(15){Array.new(15,0)}
    @map_item  = Array.new(15){Array.new(15,0)}

    #アイテムの配置情報(x座標,ｙ座標,イメージファイル)を保存する配列
    @item    = []

    #初期の方向情報を保存する
    @direction = BOTTOM

    #クラスsenro.rbを読み込む
    @senro = Senro.new()

    #線路の種類数を設定する
    senro_nam = 6

    #線路の画像を読み込む
    @senro_img = []
    senro_nam.times do |i|
      ward = "#{APP_ROOT}/images/senro/senro" + (i + 1).to_s  + ".png"
      @senro_img[i] = Image.load(ward)
    end

    #ゴールの個数を挿入する
    goal_nam = 3

    #変数goalにゴール座標のy軸を挿入する
    goal = [4,9,14]

    #ゴール画像の読み込み
    @goal_img = []
    goal_nam.times do |i|
      ward = "#{APP_ROOT}/images/point/goal" + (i + 1).to_s  + ".png"
      @goal_img[i] = Image.load(ward)
    end

    #ゴールの座標をマップの二次元配列に配置
    @rail_position = []
    i = 0
    goal.each do |a|
      @map[a][14] = 7
      @rail_position << Sprite.new( 14 * 40,  a * 40, @goal_img[i])
      i += 1
    end

    #スタートマスに線路を配置
    @map[0][0] = 1
    @map[0][1] = 4
    @rail_position << Sprite.new(0 * 40, 0 * 40, @senro_img[0])
    @rail_position << Sprite.new(1 * 40, 0 * 40, @senro_img[3])

    #初期のターゲット座標の設定
    @y_target = 1
    @x_target = 1

    #マップ上にアイテムを配置する
    #アイテムの個数
    @item_num = 13

    @item_img = []

    #アイテムの座標情報の設定
    @item_num.times do |i|
      #アイテム画像の読み込み
      word = "#{APP_ROOT}/images/point/point" + (i + 1).to_s  + ".png"
      @item_img[i]  = Image.load(word)

      #アイテムマスのx座標とy座標の指定
      loop do
        y = rand(15).to_i
        x = rand(15).to_i
        if (@map[y][x] == 0) && (@map_item[y][x] == 0)
          #アイテム用マップのアイテムマスを置く座標に値を挿入
          @map_item[y][x] = i + 1
          break
        end
      end
    end

  end

  def railInsert(kind)
                 #kind:線路の種類
    # 画面外の場合は置かない
    if @x_target < 0 || @x_target > 14 || @y_target < 0 || @y_target > 14
      return
    end

    # 既に線路が置かれていたら置かない
    if @map[@y_target][@x_target] != 0
      return
    end

    #
    if @x_target == 14
      if @y_target == 4 || @y_target == 9 || @y_target == 14
        return
      end
    end

    #配置座標をもとにマップ用の二次元配列を書き換える
    @map[@y_target][@x_target] = kind

    #配置する線路の表示画像と座標の情報を保存する
    @rail_position << Sprite.new(@x_target.to_i * 40, @y_target.to_i * 40, @senro_img[kind.to_i - 1])

    #ターゲットの座標を変更する
    self.changeDirection(kind)

    #線路を配置したSEを鳴らす
    @sound_senro.play

  end

  def changeDirection(kind)
    #senroクラスに方向情報を渡し、次のターゲット情報を更新する
    case (@direction = @senro.next_direction(kind, @direction))
      when LEFT  then
        @x_target -= 1
      when RIGHT then
        @x_target += 1
      when TOP   then
        @y_target -= 1
      else
        @y_target += 1
    end
  end

  def draw
    #線路用マップを表示する
    Sprite.draw(@rail_position)

    #アイテム用マップを表示する
    y = 0
    item_count = 0
    while item_count < @item_num
      15.times do |x|
        if @map_item[y][x] != 0
          if @map[y][x] != 0
            alpha = 128 # 透過率（0～255を指定してください）
            Window.drawAlpha(x * 40, y * 40, @item_img[@map_item[y][x]-1], 128)
          else
            Window.draw(x * 40, y * 40, @item_img[@map_item[y][x]-1])
          end
          item_count += 1
        end
      end
      y += 1
    end
  end

  def itemDel(x, y)
    @map_item[y][x] = 0
    @item_num -= 1
  end

end