# エンディングシーンの管理用クラス
class Ending
  def initialize
    @image = Util.load_image("#{APP_ROOT}images/ending_bg.png")
  end

  def play
    if Input.keyPush?(K_SPACE)
      exit
    end
    Window.draw(0, 0, @image)
    # スコアの描画
  	@@score.draw
    # @@message.drawFont

  end

  #scoreのセット,game.rbで使用
  def self.setScore(scr)
  	@@score = scr
    @@score.x, @@score.y = 0, 0
    # @@message = Image.new(0, 0, @@score.point.to_s, @@score.font, [0,0,0])
  end
end