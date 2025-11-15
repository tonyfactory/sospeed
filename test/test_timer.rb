# -*- coding: utf-8 -*-

require_relative 'test_helper'

require_relative '../lib/sospeed/timer'

class TestTimer < Minitest::Test
  def setup
    @timer = SoSpeed::Timer.new
  end

  def test_initial_state
    refute @timer.running?
    assert_equal 0, @timer.elapsed
  end

  def test_start_stop
    @timer.start
    assert @timer.running?

    sleep(0.01) # Small delay to ensure time passes
    @timer.stop
    refute @timer.running?

    elapsed = @timer.elapsed
    assert elapsed > 0, "Elapsed time should be greater than 0"
    assert elapsed < 1, "Elapsed time should be less than 1 second for this test"
  end

  def test_elapsed_without_stop
    @timer.start
    assert_equal 0, @timer.elapsed, "Elapsed time should be 0 if timer hasn't been stopped"
  end

  def test_elapsed_without_start
    @timer.stop
    assert_equal 0, @timer.elapsed, "Elapsed time should be 0 if timer hasn't been started"
  end
end
