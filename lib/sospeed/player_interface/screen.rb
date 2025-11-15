# -*- coding: utf-8 -*-

module SoSpeed
  module PlayerInterface
    class Screen
      def show_intro(question_count)
        puts "=" * 50
        puts "こんにちわ"
        puts "素数スピード練習プログラム"
        puts "=" * 50
        puts ""
        puts "ルール:"
        puts "- 表示された数字を素因数分解してください"
        puts "- 素数をスペース区切りで入力してください(例: 2 3 5)"
        puts "- 順序は問いません"
        puts "- #{question_count}問すべて解くまでの時間を計測します"
        puts ""
        puts "Enterキーを押して次へ!"
        # Bypass user input during tests
        return if ENV['RUBY_ENV'] == 'test'
        gets
      end

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

        # Bypass user input during tests
        if ENV['RUBY_ENV'] == 'test'
          difficulty = :level1
          puts "レベルを選択 (1-4) > 1"
          puts ""
          puts "難易度: #{Difficulty.get(difficulty)[:name]} が選択されました"
          puts ""
          return difficulty
        end

        difficulty = nil
        loop do
          print "レベルを選択 (1-4) > "
          input = gets.chomp

          case input
          when "1"
            difficulty = :level1
            break
          when "2"
            difficulty = :level2
            break
          when "3"
            difficulty = :level3
            break
          when "4"
            difficulty = :level4
            break
          else
            puts "1, 2, 3, 4のいずれかを入力してください"
          end
        end

        puts ""
        puts "難易度: #{Difficulty.get(difficulty)[:name]} が選択されました"
        puts ""

        difficulty
      end

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

        # Bypass user input during tests
        if ENV['RUBY_ENV'] == 'test'
          input_mode = :space_separated
          puts "操作方法を選択 (1-2) > 1"
          puts ""
          puts "操作方法: スペース区切り入力方式 が選択されました"
          puts ""
          return input_mode
        end

        input_mode = nil
        loop do
          print "操作方法を選択 (1-2) > "
          input = gets.chomp

          case input
          when "1"
            input_mode = :space_separated
            break
          when "2"
            input_mode = :keyboard_mapping
            break
          else
            puts "1, 2のいずれかを入力してください"
          end
        end

        puts ""
        mode_name = input_mode == :space_separated ? "スペース区切り入力方式" : "キーボード割り当て方式"
        puts "操作方法: #{mode_name} が選択されました"
        puts ""

        input_mode
      end

      def show_start_prompt
        puts "Enterキーを押してスタート!"
        # Bypass user input during tests
        return if ENV['RUBY_ENV'] == 'test'
        gets
      end

      def show_question(number, question)
        puts ""
        puts "-" * 50
        puts "第#{number}問: #{question[:number]}"
        puts "-" * 50
      end

      def show_correct
        puts "正解!"
      end

      def show_incorrect
        puts "不正解です"
        sleep(Question::Validator::ERROR_WAIT_TIME)
      end

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
  end
end
