#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'set'

# 素数スピード練習プログラム

class SoSpeed
  PRIMES_BASIC = [2, 3, 5, 7]
  PRIMES_ADVANCED = [2, 3, 5, 7, 11]
  QUESTION_COUNT = 5
  ERROR_WAIT_TIME = 2

  # 難易度設定
  DIFFICULTY_SETTINGS = {
    level1: {
      name: "レベル1",
      primes: PRIMES_BASIC,
      factor_count: (2..2),
      max_number: 50
    },
    level2: {
      name: "レベル2",
      primes: PRIMES_BASIC,
      factor_count: (3..3),
      max_number: 500
    },
    level3: {
      name: "レベル3",
      primes: PRIMES_ADVANCED,
      factor_count: (4..4),
      max_number: 1000
    },
    level4: {
      name: "レベル4",
      primes: PRIMES_ADVANCED,
      factor_count: (4..5),
      max_number: 10000
    }
  }

  def initialize
    @questions = []
    @start_time = nil
    @difficulty = nil
  end

  # 難易度を選択
  def select_difficulty
    puts ""
    puts "=" * 50
    puts "難易度を選択してください"
    puts "=" * 50
    puts ""
    puts "1. レベル1 (素数: 2,3,5,7 / 2個 / 数字50まで)"
    puts "2. レベル2 (素数: 2,3,5,7 / 3個 / 数字500まで)"
    puts "3. レベル3 (素数: 2,3,5,7,11 / 4個 / 数字1000まで)"
    puts "4. レベル4 (素数: 2,3,5,7,11 / 4〜5個 / 数字10000まで)"
    puts ""

    loop do
      print "レベルを選択 (1-4) > "
      input = gets.chomp

      case input
      when "1"
        @difficulty = :level1
        break
      when "2"
        @difficulty = :level2
        break
      when "3"
        @difficulty = :level3
        break
      when "4"
        @difficulty = :level4
        break
      else
        puts "1, 2, 3, 4のいずれかを入力してください"
      end
    end

    puts ""
    puts "難易度: #{DIFFICULTY_SETTINGS[@difficulty][:name]} が選択されました"
    puts ""
  end

  # 問題を生成
  def generate_questions
    settings = DIFFICULTY_SETTINGS[@difficulty]
    primes = settings[:primes]
    factor_range = settings[:factor_count]
    max_number = settings[:max_number]

    used_numbers = Set.new  # 既に使用した数値を記録

    QUESTION_COUNT.times do
      # 上限を超えない、かつ重複しない数を生成するまでループ
      loop do
        count = rand(factor_range)
        factors = Array.new(count) { primes.sample }
        number = factors.reduce(:*)

        # 上限以下で、かつ未使用の数値の場合のみ問題として採用
        if number <= max_number && !used_numbers.include?(number)
          used_numbers.add(number)
          @questions << { number: number, factors: factors.sort }
          break
        end
      end
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
    puts "Enterキーを押して次へ!"
    gets

    # 難易度選択
    select_difficulty

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