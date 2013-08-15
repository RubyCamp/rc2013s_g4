# 難易度設定シーンの管理用クラス
class Dificulty
  def initialize
    @image = Util.load_image("#{APP_ROOT}images/title_select.png")
  end

  def play
    if Input.keyPush?(K_1)
      Game.set_mode("EASY")
      Director.gameInitialize
      Director.change_scene(:game)
    elsif Input.keyPush?(K_2)
      Game.set_mode("NORMAL")
      Director.gameInitialize
      Director.change_scene(:game)
    elsif Input.keyPush?(K_3)
      Game.set_mode("HARD")
      Director.gameInitialize
      Director.change_scene(:game)
    end

    #中央に表示
    Window.draw(0, 0, @image)
  end

end
