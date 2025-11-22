# -*- coding: utf-8 -*-

require_relative '../test_helper'

require_relative '../../lib/sospeed/question/generator'

class TestGenerator < Minitest::Test
  def setup
    @difficulty_settings = {
      name: "テスト用",
      primes: [2, 3, 5],
      factor_count: (2..3),
      min_number: 0,
      max_number: 100
    }
    @generator = SoSpeed::Question::Generator.new(@difficulty_settings)
  end

  def test_generate_count
    questions = @generator.generate(5)
    assert_equal 5, questions.size
  end

  def test_generate_unique_numbers
    questions = @generator.generate(10)
    numbers = questions.map { |q| q[:number] }
    assert_equal numbers.uniq.size, numbers.size, "Generated numbers should be unique"
  end

  def test_generate_within_max_number
    questions = @generator.generate(10)
    questions.each do |question|
      assert question[:number] <= @difficulty_settings[:max_number],
             "Generated number #{question[:number]} exceeds max_number #{@difficulty_settings[:max_number]}"
    end
  end

  def test_generate_within_min_number
    questions = @generator.generate(10)
    questions.each do |question|
      assert question[:number] >= @difficulty_settings[:min_number],
             "Generated number #{question[:number]} is below min_number #{@difficulty_settings[:min_number]}"
    end
  end

  def test_generate_factors_within_range
    questions = @generator.generate(10)
    questions.each do |question|
      assert @difficulty_settings[:factor_count].include?(question[:factors].size),
             "Factor count #{question[:factors].size} is outside the allowed range #{@difficulty_settings[:factor_count]}"
    end
  end

  def test_generate_factors_from_primes
    questions = @generator.generate(10)
    questions.each do |question|
      question[:factors].each do |factor|
        assert_includes @difficulty_settings[:primes], factor,
                       "Factor #{factor} is not in the allowed primes #{@difficulty_settings[:primes]}"
      end
    end
  end

  def test_generate_correct_product
    questions = @generator.generate(10)
    questions.each do |question|
      product = question[:factors].reduce(:*)
      assert_equal question[:number], product,
                   "Number #{question[:number]} does not match the product of its factors #{question[:factors]}"
    end
  end

  def test_generate_with_min_number_constraint
    # 下限50の設定でテスト
    settings_with_min = {
      name: "下限テスト用",
      primes: [2, 3, 5, 7],
      factor_count: (3..3),
      min_number: 50,
      max_number: 500
    }
    generator = SoSpeed::Question::Generator.new(settings_with_min)
    questions = generator.generate(10)

    questions.each do |question|
      assert question[:number] >= 50,
             "Generated number #{question[:number]} is below min_number 50"
      assert question[:number] <= 500,
             "Generated number #{question[:number]} exceeds max_number 500"
    end
  end
end
