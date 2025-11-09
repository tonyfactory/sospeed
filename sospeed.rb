#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'set'
require 'io/console'
require 'optparse'

# 素数スピード練習プログラム

class SoSpeed
  PRIMES_BASIC = [2, 3, 5, 7]
  PRIMES_ADVANCED = [2, 3, 5, 7, 11]
  DEFAULT_QUESTION_COUNT = 5
  ERROR_WAIT_TIME = 2

  # キーボード割り当て
  KEY_MAPPING = {
    'a' => 2,
    's' => 3,
    'd' => 5,
    'f' => 7,
    'g' => 11
  }

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

  def initialize(difficulty: nil, input_mode: nil, question_count: nil)
    @questions = []
    @start_time = nil
    @difficulty = difficulty
    @input_mode = input_mode
    @question_count = question_count || DEFAULT_QUESTION_COUNT
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

  # 操作方法を選択
  def select_input_mode
    puts ""
    puts "=" * 50
    puts "操作方法を選択してください"
    puts "=" * 50
    puts ""
    puts "1. スペース区切り入力方式"
    puts "   例: 2 3 5 と入力してEnter"
    puts ""
    puts "2. キーボード割り当て方式"
    puts "   a:2  s:3  d:5  f:7  g:11"
    puts "   キーを押すと数字が表示され、Enterで確定"
    puts "   Backspaceで削除可能"
    puts ""

    loop do
      print "操作方法を選択 (1-2) > "
      input = gets.chomp

      case input
      when "1"
        @input_mode = :space_separated
        break
      when "2"
        @input_mode = :keyboard_mapping
        break
      else
        puts "1, 2のいずれかを入力してください"
      end
    end

    puts ""
    mode_name = @input_mode == :space_separated ? "スペース区切り入力方式" : "キーボード割り当て方式"
    puts "操作方法: #{mode_name} が選択されました"
    puts ""
  end

  # 問題を生成
  def generate_questions
    settings = DIFFICULTY_SETTINGS[@difficulty]
    primes = settings[:primes]
    factor_range = settings[:factor_count]
    max_number = settings[:max_number]

    used_numbers = Set.new  # 既に使用した数値を記録

    @question_count.times do
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
    puts "- #{@question_count}問すべて解くまでの時間を計測します"
    puts ""
    puts "Enterキーを押して次へ!"
    gets

    # 難易度選択（オプション指定がない場合のみ）
    select_difficulty if @difficulty.nil?

    # 操作方法選択（オプション指定がない場合のみ）
    select_input_mode if @input_mode.nil?

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

  # キーボード割り当て方式で入力
  def input_with_keyboard_mapping
    factors = []

    print "素因数を入力 > "
    STDOUT.flush

    loop do
      char = STDIN.getch

      case char
      when "\r", "\n"  # Enter
        puts ""
        break
      when "\u007F", "\b"  # Backspace (127) or Backspace (8)
        unless factors.empty?
          last_factor = factors.pop
          # 削除する文字数を計算（数値の桁数 + スペース1文字）
          delete_count = last_factor.to_s.length + 1
          # その文字数分バックスペース処理
          delete_count.times { print "\b \b" }
          STDOUT.flush
        end
      when *KEY_MAPPING.keys  # a, s, d, f, g
        prime = KEY_MAPPING[char]
        factors << prime
        print "#{prime} "
        STDOUT.flush
      when "\u0003"  # Ctrl+C
        puts ""
        exit
      # その他のキーは無視
      end
    end

    factors.join(' ')
  end

  # 1問を解く
  def solve_question(question, question_number)
    puts ""
    puts "-" * 50
    puts "第#{question_number}問: #{question[:number]}"
    puts "-" * 50

    loop do
      # 入力方式に応じた入力方法を選択
      input = if @input_mode == :keyboard_mapping
                input_with_keyboard_mapping
              else
                print "素因数を入力 > "
                gets.chomp
              end

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

# コマンドラインオプション解析
def parse_options
  options = {}

  OptionParser.new do |opts|
    opts.banner = "使用方法: ruby sospeed.rb [オプション]"
    opts.separator ""
    opts.separator "オプション:"

    opts.on("--level LEVEL", Integer, "難易度を指定 (1-4)") do |level|
      unless (1..4).include?(level)
        puts "=" * 60
        puts "エラー: レベルは1〜4の範囲で指定してください"
        puts "=" * 60
        puts ""
        puts "利用可能なレベル:"
        puts ""
        puts "  レベル1: 素数 2,3,5,7 を使用 / 2個の素数 / 数字50まで / 5問"
        puts "  レベル2: 素数 2,3,5,7 を使用 / 3個の素数 / 数字500まで / 5問"
        puts "  レベル3: 素数 2,3,5,7,11 を使用 / 4個の素数 / 数字1000まで / 5問"
        puts "  レベル4: 素数 2,3,5,7,11 を使用 / 4〜5個の素数 / 数字10000まで / 5問"
        puts ""
        puts "例: ruby sospeed.rb --level 3"
        puts "=" * 60
        exit 1
      end
      options[:difficulty] = :"level#{level}"
    end

    opts.on("--mode MODE", Integer, "入力モードを指定 (1=スペース区切り, 2=キーボード割り当て)") do |mode|
      unless (1..2).include?(mode)
        puts "=" * 60
        puts "エラー: モードは1または2を指定してください"
        puts "=" * 60
        puts ""
        puts "利用可能な入力モード:"
        puts ""
        puts "  モード1: スペース区切り入力方式"
        puts "    - 素因数を半角スペース区切りで入力"
        puts "    - 例: 2 3 5 と入力してEnterキーで確定"
        puts "    - 順序は問いません（2 5 3 でも正解）"
        puts ""
        puts "  モード2: キーボード割り当て方式"
        puts "    - キーボードに素数を割り当て"
        puts "    - a:2  s:3  d:5  f:7  g:11"
        puts "    - キーを押すと数字が表示され、Enterで確定"
        puts "    - Backspaceで削除可能"
        puts ""
        puts "例: ruby sospeed.rb --mode 2"
        puts "=" * 60
        exit 1
      end
      options[:input_mode] = mode == 1 ? :space_separated : :keyboard_mapping
    end

    opts.on("-q", "--questions NUM", Integer, "問題数を指定（裏モード）") do |num|
      unless (1..100).include?(num)
        puts "=" * 60
        puts "エラー: 問題数は1〜100の範囲で指定してください"
        puts "=" * 60
        puts ""
        puts "例: ruby sospeed.rb --questions 10"
        puts "    ruby sospeed.rb -q 20"
        puts ""
        puts "=" * 60
        exit 1
      end
      options[:question_count] = num
    end

    opts.on("-h", "--help", "このヘルプを表示") do
      puts opts
      exit
    end
  end.parse!

  options
end

# ゲーム実行
if __FILE__ == $0
  options = parse_options
  game = SoSpeed.new(
    difficulty: options[:difficulty],
    input_mode: options[:input_mode],
    question_count: options[:question_count]
  )
  game.start
end