# タイトル（オープニング）シーンの管理用クラス
class Title
  def initialize
    @image = Util.load_image("#{APP_ROOT}images/title_1.png")
  end

  def play
    if Input.keyPush?(K_SPACE)
      Director.change_scene(:dificulty)
    end
    #中央に表示
    Window.draw(0, 0, @image)
  end
end
