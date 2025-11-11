# -*- coding: utf-8 -*-

module SoSpeed
  VERSION = "2.0.0"
end

# 依存ファイルの読み込み
require_relative 'sospeed/difficulty'
require_relative 'sospeed/timer'
require_relative 'sospeed/question/generator'
require_relative 'sospeed/question/validator'
require_relative 'sospeed/player_interface/keyboard'
require_relative 'sospeed/player_interface/input_reader'
require_relative 'sospeed/player_interface/screen'
require_relative 'sospeed/game_engine'
