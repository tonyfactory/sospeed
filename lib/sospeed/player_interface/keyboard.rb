# -*- coding: utf-8 -*-
require 'io/console'

module SoSpeed
  module PlayerInterface
    class Keyboard
      KEY_MAPPING = {
        'a' => 2,
        's' => 3,
        'd' => 5,
        'f' => 7,
        'g' => 11
      }

      def read_with_mapping
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
            handle_backspace(factors)
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

      private

      def handle_backspace(factors)
        unless factors.empty?
          last_factor = factors.pop
          # 削除する文字数を計算（数値の桁数 + スペース1文字）
          delete_count = last_factor.to_s.length + 1
          # その文字数分バックスペース処理
          delete_count.times { print "\b \b" }
          STDOUT.flush
        end
      end
    end
  end
end
