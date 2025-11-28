# -*- coding: utf-8 -*-

require_relative '../test_helper'
require 'stringio'

require_relative '../../lib/sospeed/player_interface/screen'
require_relative '../../lib/sospeed/difficulty'
require_relative '../../lib/sospeed/question/validator'

class TestScreen < Minitest::Test
  def setup
    @screen = SoSpeed::PlayerInterface::Screen.new
    @original_stdout = $stdout
    @original_stdin = $stdin
    @stdout = StringIO.new
    $stdout = @stdout
  end

  def teardown
    $stdout = @original_stdout
    $stdin = @original_stdin
  end

  def test_show_intro
    $stdin = StringIO.new("\n")
    @screen.show_intro(10)
    output = @stdout.string

    assert_includes output, "素数スピード練習プログラム"
    assert_includes output, "10問すべて解くまでの時間を計測します"
  end

  def test_select_difficulty_level1
    $stdin = StringIO.new("1\n")
    difficulty = @screen.select_difficulty
    output = @stdout.string

    assert_equal :level1, difficulty
    assert_includes output, "レベル1 (素数: 2,3,5,7 / 2個 / 数字50まで)"
    assert_includes output, "難易度: レベル1 が選択されました"
  end

  def test_select_difficulty_invalid_then_valid
    $stdin = StringIO.new("0\n1\n")
    difficulty = @screen.select_difficulty
    output = @stdout.string

    assert_equal :level1, difficulty
    assert_includes output, "1, 2, 3, 4のいずれかを入力してください"
  end

  def test_select_input_mode_space_separated
    $stdin = StringIO.new("1\n")
    mode = @screen.select_input_mode
    output = @stdout.string

    assert_equal :space_separated, mode
    assert_includes output, "スペース区切り入力方式 が選択されました"
  end

  def test_select_input_mode_keyboard_mapping
    $stdin = StringIO.new("2\n")
    mode = @screen.select_input_mode
    output = @stdout.string

    assert_equal :keyboard_mapping, mode
    assert_includes output, "キーボード割り当て方式 が選択されました"
  end

  def test_show_start_prompt
    $stdin = StringIO.new("\n")
    @screen.show_start_prompt
    output = @stdout.string

    assert_includes output, "Enterキーを押してスタート!"
  end

  def test_show_question
    question = { number: 6, factors: [2, 3] }
    @screen.show_question(1, question)
    output = @stdout.string

    assert_includes output, "第1問: 6"
  end

  def test_show_correct
    @screen.show_correct
    output = @stdout.string

    assert_includes output, "正解!"
  end

  def test_show_result
    question_times = [
      { number: 6, factors: [2, 3], elapsed: 3.5 },
      { number: 15, factors: [3, 5], elapsed: 7.0 }
    ]
    @screen.show_result(10.5, question_times)
    output = @stdout.string

    assert_includes output, "合計時間: 10.50秒"
    assert_includes output, "第1問: 6 = 2 × 3 (3.50秒)"
    assert_includes output, "第2問: 15 = 3 × 5 (7.00秒)"
  end
end
