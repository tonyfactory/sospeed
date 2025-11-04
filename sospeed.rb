#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 素数スピード練習プログラム

class SoSpeed
  PRIMES = [2, 3, 5, 7]
  QUESTION_COUNT = 5
  ERROR_WAIT_TIME = 2

  def initialize
    @questions = []
    @start_time = nil
  end

  # 問題を生成
  def generate_questions
    QUESTION_COUNT.times do
      # 2〜3個の素数を選ぶ
      count = rand(2..3)
      factors = Array.new(count) { PRIMES.sample }
      number = factors.reduce(:*)
      @questions << { number: number, factors: factors.sort }
    end
  end

  # ゲーム開始
  def start
    puts "=" * 50
    puts "素数スピード練習プログラム"
    puts "=" * 50
    puts ""
    puts "ルール:"
    puts "- 表示された数字を素因数分解してください"
    puts "- 素数をスペース区切りで入力してください(例: 2 3 5)"
    puts "- 順序は問いません"
    puts "- #{QUESTION_COUNT}問すべて解くまでの時間を計測します"
    puts ""
    puts "Enterキーを押してスタート!"
    gets

    generate_questions
    @start_time = Time.now

    @questions.each_with_index do |q, index|
      solve_question(q, index + 1)
    end

    end_time = Time.now
    elapsed_time = end_time - @start_time

    show_result(elapsed_time)
  end

  # 1問を解く
  def solve_question(question, question_number)
    puts ""
    puts "-" * 50
    puts "第#{question_number}問: #{question[:number]}"
    puts "-" * 50

    loop do
      print "素因数を入力 > "
      input = gets.chomp

      # 空白入力は無視
      if input.empty?
        next
      end

      # 入力の検証
      unless valid_input?(input)
        puts "数字を入力してください"
        sleep(ERROR_WAIT_TIME)
        next
      end

      # 入力をパース
      user_factors = input.split.map(&:to_i).sort

      # 正解判定
      if user_factors == question[:factors]
        puts "正解!"
        break
      else
        puts "不正解です"
        sleep(ERROR_WAIT_TIME)
      end
    end
  end

  # 入力が有効かチェック
  def valid_input?(input)
    # 半角数字と半角スペースのみを許容
    input.match?(/^[0-9 ]+$/)
  end

  # 結果表示
  def show_result(elapsed_time)
    puts ""
    puts "=" * 50
    puts "お疲れ様でした!"
    puts "=" * 50
    puts ""
    printf "合計時間: %.2f秒\n", elapsed_time
    puts ""
    puts "=" * 50
  end
end

# ゲーム実行
if __FILE__ == $0
  game = SoSpeed.new
  game.start
end