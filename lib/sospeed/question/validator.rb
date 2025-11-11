# -*- coding: utf-8 -*-

module SoSpeed
  module Question
    class Validator
      ERROR_WAIT_TIME = 2

      def correct?(user_input, question)
        return false if user_input.nil? || user_input.empty?

        # 入力が有効かチェック
        unless valid_input?(user_input)
          puts "数字を入力してください"
          sleep(ERROR_WAIT_TIME)
          return false
        end

        # 入力をパース
        user_factors = user_input.split.map(&:to_i).sort

        # 正解判定
        user_factors == question[:factors]
      end

      private

      def valid_input?(input)
        # 半角数字と半角スペースのみを許容
        input.match?(/^[0-9 ]+$/)
      end
    end
  end
end
