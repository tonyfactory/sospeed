# -*- coding: utf-8 -*-

module SoSpeed
  module PlayerInterface
    class InputReader
      def initialize
        @keyboard = Keyboard.new
      end

      def read(mode)
        case mode
        when :space_separated
          read_space_separated
        when :keyboard_mapping
          read_keyboard_mapping
        end
      end

      private

      def read_space_separated
        print "素因数を入力 > "
        gets.chomp
      end

      def read_keyboard_mapping
        @keyboard.read_with_mapping
      end
    end
  end
end
