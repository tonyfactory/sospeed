# -*- coding: utf-8 -*-
require 'set'

module SoSpeed
  module Question
    class Generator
      def initialize(difficulty_settings)
        @settings = difficulty_settings
      end

      def generate(count)
        primes = @settings[:primes]
        factor_range = @settings[:factor_count]
        max_number = @settings[:max_number]

        questions = []
        used_numbers = Set.new

        count.times do
          loop do
            factor_count = rand(factor_range)
            factors = Array.new(factor_count) { primes.sample }
            number = factors.reduce(:*)

            # 上限以下で、かつ未使用の数値の場合のみ採用
            if number <= max_number && !used_numbers.include?(number)
              used_numbers.add(number)
              questions << { number: number, factors: factors.sort }
              break
            end
          end
        end

        questions
      end
    end
  end
end
