# -*- coding: utf-8 -*-

require_relative 'test_helper'

require_relative '../lib/sospeed/difficulty'

class TestDifficulty < Minitest::Test
  def test_get_level1
    level1 = SoSpeed::Difficulty.get(:level1)
    assert_equal "レベル1", level1[:name]
    assert_equal [2, 3, 5, 7], level1[:primes]
    assert_equal (2..2), level1[:factor_count]
    assert_equal 50, level1[:max_number]
  end

  def test_get_level2
    level2 = SoSpeed::Difficulty.get(:level2)
    assert_equal "レベル2", level2[:name]
    assert_equal [2, 3, 5, 7], level2[:primes]
    assert_equal (3..3), level2[:factor_count]
    assert_equal 500, level2[:max_number]
  end

  def test_get_level3
    level3 = SoSpeed::Difficulty.get(:level3)
    assert_equal "レベル3", level3[:name]
    assert_equal [2, 3, 5, 7, 11], level3[:primes]
    assert_equal (4..4), level3[:factor_count]
    assert_equal 1000, level3[:max_number]
  end

  def test_get_level4
    level4 = SoSpeed::Difficulty.get(:level4)
    assert_equal "レベル4", level4[:name]
    assert_equal [2, 3, 5, 7, 11], level4[:primes]
    assert_equal (4..5), level4[:factor_count]
    assert_equal 10000, level4[:max_number]
  end

  def test_all
    all_levels = SoSpeed::Difficulty.all
    assert_equal 4, all_levels.size
    assert_includes all_levels.keys, :level1
    assert_includes all_levels.keys, :level2
    assert_includes all_levels.keys, :level3
    assert_includes all_levels.keys, :level4
  end
end
