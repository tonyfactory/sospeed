# -*- coding: utf-8 -*-

require_relative '../test_helper'
require 'stringio'

require_relative '../../lib/sospeed/player_interface/keyboard'

class TestKeyboard < Minitest::Test
  def setup
    @keyboard = SoSpeed::PlayerInterface::Keyboard.new
    @original_stdout = $stdout
    @original_stdin = STDIN
    @stdout = StringIO.new
    $stdout = @stdout
  end

  def teardown
    $stdout = @original_stdout
    # Restore STDIN if it was replaced
    if defined?(@getch_io)
      Object.send(:remove_const, :STDIN)
      Object.const_set(:STDIN, @original_stdin)
    end
  end

  # This test is a bit tricky because we need to mock STDIN.getch
  # We'll use a custom StringIO-like class that implements getch
  def test_read_with_mapping
    # Mock STDIN with our custom GetchIO class
    @getch_io = GetchIO.new(['a', 's', "\r"])
    suppress_warnings { Object.const_set(:STDIN, @getch_io) }

    result = @keyboard.read_with_mapping
    output = @stdout.string

    assert_equal "2 3", result
    assert_includes output, "素因数を入力 >"
  end

  def test_read_with_mapping_with_backspace
    # Test with a backspace character
    @getch_io = GetchIO.new(['a', 's', "\u007F", 'd', "\r"])
    suppress_warnings { Object.const_set(:STDIN, @getch_io) }

    result = @keyboard.read_with_mapping

    assert_equal "2 5", result
  end

  def test_read_with_mapping_with_invalid_keys
    # Test with some invalid keys that should be ignored
    @getch_io = GetchIO.new(['a', 'x', 'y', 's', "\r"])
    suppress_warnings { Object.const_set(:STDIN, @getch_io) }

    result = @keyboard.read_with_mapping

    assert_equal "2 3", result
  end

  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    yield
  ensure
    $VERBOSE = original_verbosity
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
