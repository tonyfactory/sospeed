# -*- coding: utf-8 -*-

require_relative '../test_helper'

require_relative '../../lib/sospeed/question/validator'

class TestValidator < Minitest::Test
  def setup
    @validator = SoSpeed::Question::Validator.new
    @question = { number: 6, factors: [2, 3] }
  end

  def test_correct_answer
    assert @validator.correct?('2 3', @question)
    assert @validator.correct?('3 2', @question)
  end

  def test_incorrect_answer
    refute @validator.correct?('2 2', @question)
    refute @validator.correct?('3 3', @question)
    refute @validator.correct?('2', @question)
    refute @validator.correct?('3', @question)
    refute @validator.correct?('2 3 5', @question)
  end

  def test_empty_input
    refute @validator.correct?('', @question)
    refute @validator.correct?(nil, @question)
  end

  def test_invalid_input
    # Temporarily redirect stdout to avoid printing error messages during tests
    original_stdout = $stdout
    $stdout = File.open(File::NULL, 'w')

    refute @validator.correct?('a b', @question)
    refute @validator.correct?('2a 3', @question)
    refute @validator.correct?('2,3', @question)

    # Restore stdout
    $stdout = original_stdout
  end
end
