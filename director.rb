require_relative 'lib/hand'
require_relative 'lib/util2'

require_relative 'scene/title'
require_relative 'scene/dificulty'
require_relative 'scene/game'
require_relative 'scene/ending'
require_relative 'scene/over'

# ゲーム進行管理用クラス
class Director
  attr_accessor :dificulty

  # 初期化処理
  def initialize
    # ゲームを構成する各シーンの管理オブジェクトを生成
    @@dificulty = EASY
    @@scenes = {}
    @@scenes[:title]  = Title.new
    @@scenes[:dificulty] = Dificulty.new
    # @@scenes[:game]   = Game.new
    @@scenes[:ending] = Ending.new
    @@scenes[:over] = Over.new
    @@current_scene = :title
  end

  def self.gameInitialize
    @@scenes[:game]   = Game.new
  end

  # シーン進行メソッド
  def play
    # 現在設定されているシーン管理オブジェクトのplayメソッドへ
    # 処理を委譲する
    @@scenes[@@current_scene].play
  end

  # シーン切り替え用メソッド
  # ===引数
  # scene: 切り替え先シーンの名称
  #        シンボルで指定する（例： Director.change_scene(:ending)）
  def self.change_scene(scene)
    @@current_scene = scene
  end
end