# -*- coding: utf-8 -*-

require_relative '../test_helper'
require 'stringio'

require_relative '../../lib/sospeed/player_interface/input_reader'

class TestInputReader < Minitest::Test
  def setup
    @original_stdout = $stdout
    @original_stdin = $stdin
    @stdout = StringIO.new
    $stdout = @stdout
  end

  def teardown
    $stdout = @original_stdout
    $stdin = @original_stdin
  end

  def test_read_space_separated
    $stdin = StringIO.new("2 3 5\n")
    input_reader = SoSpeed::PlayerInterface::InputReader.new

    result = input_reader.read(:space_separated)
    output = @stdout.string

    assert_equal "2 3 5", result
    assert_includes output, "素因数を入力 >"
  end

  def test_read_keyboard_mapping
    # For this test, we need to mock the Keyboard class
    keyboard_mock = Minitest::Mock.new
    keyboard_mock.expect(:read_with_mapping, "2 3")

    # Replace the Keyboard class with our mock
    SoSpeed::PlayerInterface::InputReader.class_eval do
      alias_method :original_initialize, :initialize

      def initialize(keyboard = nil)
        @keyboard = keyboard if keyboard
      end
    end

    input_reader = SoSpeed::PlayerInterface::InputReader.new(keyboard_mock)
    result = input_reader.read(:keyboard_mapping)

    assert_equal "2 3", result
    keyboard_mock.verify

    # Restore the original initialize method
    SoSpeed::PlayerInterface::InputReader.class_eval do
      alias_method :initialize, :original_initialize
      remove_method :original_initialize
    end
  end
end
