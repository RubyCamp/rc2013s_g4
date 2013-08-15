# ゲームオーバーシーンの管理用クラス
class Over
  def initialize
    @image = Util.load_image("#{APP_ROOT}images/gameover.png")
  end

  def play
    if Input.keyPush?(K_SPACE)
      exit
    end
    Window.draw(0, 0, @image)

  	# スコアの描画
  	@@score.draw
  end
  #scoreのセット,game.rbで使用
  def self.setScore(scr)
  	@@score = scr
    @@score.y = 80
    @@score.x = 620
  end

end