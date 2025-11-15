# -*- coding: utf-8 -*-

require_relative '../test_helper'
require 'stringio'

require_relative '../../lib/sospeed/player_interface/keyboard'

class TestKeyboard < Minitest::Test
  def setup
    @keyboard = SoSpeed::PlayerInterface::Keyboard.new
    @original_stdout = $stdout
    @original_stdin = $stdin
    @stdout = StringIO.new
    $stdout = @stdout
  end

  def teardown
    $stdout = @original_stdout
    $stdin = @original_stdin
  end

  # This test is a bit tricky because we need to mock STDIN.getch
  # We'll use a custom StringIO-like class that implements getch
  def test_read_with_mapping
    # Mock STDIN with our custom GetchIO class
    $stdin = GetchIO.new(['a', 's', "\r"])

    result = @keyboard.read_with_mapping
    output = @stdout.string

    assert_equal "2 3", result
    assert_includes output, "素因数を入力 >"
    assert_includes output, "2 3"
  end

  def test_read_with_mapping_with_backspace
    # Test with a backspace character
    $stdin = GetchIO.new(['a', 's', "\u007F", 'd', "\r"])

    result = @keyboard.read_with_mapping

    assert_equal "2 5", result
  end

  def test_read_with_mapping_with_invalid_keys
    # Test with some invalid keys that should be ignored
    $stdin = GetchIO.new(['a', 'x', 'y', 's', "\r"])

    result = @keyboard.read_with_mapping

    assert_equal "2 3", result
  end

  # Custom class to mock STDIN.getch
  class GetchIO
    def initialize(chars)
      @chars = chars
    end

    def getch
      @chars.shift
    end
  end
end
