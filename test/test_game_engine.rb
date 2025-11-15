# -*- coding: utf-8 -*-

require_relative 'test_helper'

require_relative '../lib/sospeed/game_engine'

class TestGameEngine < Minitest::Test
  def setup
    # Mock all dependencies
    @screen_mock = Minitest::Mock.new
    @input_reader_mock = Minitest::Mock.new
    @validator_mock = Minitest::Mock.new
    @timer_mock = Minitest::Mock.new
    @generator_mock = Minitest::Mock.new

    # Stub the constructor of each dependency class
    stub_constructors
  end

  def teardown
    # Restore original methods
    restore_constructors
  end

  def test_start_with_predefined_options
    difficulty = :level1
    input_mode = :space_separated
    question_count = 3

    # Setup expectations for mocks
    setup_expectations_for_predefined_options(difficulty, input_mode, question_count)

    # Create game engine with predefined options
    game_engine = SoSpeed::GameEngine.new(
      difficulty: difficulty,
      input_mode: input_mode,
      question_count: question_count
    )

    # Run the game
    game_engine.start

    # Verify all mocks
    @screen_mock.verify
    @input_reader_mock.verify
    @validator_mock.verify
    @timer_mock.verify
    @generator_mock.verify
  end

  def test_start_with_user_selected_options
    question_count = 3

    # Setup expectations for mocks
    setup_expectations_for_user_selected_options(question_count)

    # Create game engine with only question_count
    game_engine = SoSpeed::GameEngine.new(question_count: question_count)

    # Run the game
    game_engine.start

    # Verify all mocks
    @screen_mock.verify
    @input_reader_mock.verify
    @validator_mock.verify
    @timer_mock.verify
    @generator_mock.verify
  end

  private

  def stub_constructors
    # Store original methods
    @original_screen_new = SoSpeed::PlayerInterface::Screen.method(:new)
    @original_input_reader_new = SoSpeed::PlayerInterface::InputReader.method(:new)
    @original_validator_new = SoSpeed::Question::Validator.method(:new)
    @original_timer_new = SoSpeed::Timer.method(:new)
    @original_generator_new = SoSpeed::Question::Generator.method(:new)

    # Stub constructors to return mocks
    SoSpeed::PlayerInterface::Screen.define_singleton_method(:new) { |*args| @screen_mock }
    SoSpeed::PlayerInterface::InputReader.define_singleton_method(:new) { |*args| @input_reader_mock }
    SoSpeed::Question::Validator.define_singleton_method(:new) { |*args| @validator_mock }
    SoSpeed::Timer.define_singleton_method(:new) { |*args| @timer_mock }
    SoSpeed::Question::Generator.define_singleton_method(:new) { |*args| @generator_mock }
  end

  def restore_constructors
    # Restore original methods
    SoSpeed::PlayerInterface::Screen.define_singleton_method(:new, @original_screen_new)
    SoSpeed::PlayerInterface::InputReader.define_singleton_method(:new, @original_input_reader_new)
    SoSpeed::Question::Validator.define_singleton_method(:new, @original_validator_new)
    SoSpeed::Timer.define_singleton_method(:new, @original_timer_new)
    SoSpeed::Question::Generator.define_singleton_method(:new, @original_generator_new)
  end

  def setup_expectations_for_predefined_options(difficulty, input_mode, question_count)
    # Mock difficulty settings
    difficulty_settings = {
      name: "レベル1",
      primes: [2, 3, 5, 7],
      factor_count: (2..2),
      max_number: 50
    }

    # Mock questions
    questions = [
      { number: 6, factors: [2, 3] },
      { number: 10, factors: [2, 5] },
      { number: 14, factors: [2, 7] }
    ]

    # Setup expectations
    @screen_mock.expect(:show_intro, nil, [question_count])
    @screen_mock.expect(:show_start_prompt, nil)

    # Stub Difficulty.get
    SoSpeed::Difficulty.stub(:get, difficulty_settings) do
      @generator_mock.expect(:generate, questions, [question_count])

      @timer_mock.expect(:start, nil)

      # For each question
      questions.each_with_index do |question, index|
        @screen_mock.expect(:show_question, nil, [index + 1, question])
        @input_reader_mock.expect(:read, "2 3", [input_mode])
        @validator_mock.expect(:correct?, true, ["2 3", question])
        @screen_mock.expect(:show_correct, nil)
      end

      @timer_mock.expect(:stop, nil)
      @timer_mock.expect(:elapsed, 10.5)
      @screen_mock.expect(:show_result, nil, [10.5])

      # This block is empty because we're just setting up expectations
    end
  end

  def setup_expectations_for_user_selected_options(question_count)
    # Mock difficulty settings
    difficulty_settings = {
      name: "レベル1",
      primes: [2, 3, 5, 7],
      factor_count: (2..2),
      max_number: 50
    }

    # Mock questions
    questions = [
      { number: 6, factors: [2, 3] },
      { number: 10, factors: [2, 5] },
      { number: 14, factors: [2, 7] }
    ]

    # Setup expectations
    @screen_mock.expect(:show_intro, nil, [question_count])
    @screen_mock.expect(:select_difficulty, :level1)
    @screen_mock.expect(:select_input_mode, :space_separated)
    @screen_mock.expect(:show_start_prompt, nil)

    # Stub Difficulty.get
    SoSpeed::Difficulty.stub(:get, difficulty_settings) do
      @generator_mock.expect(:generate, questions, [question_count])

      @timer_mock.expect(:start, nil)

      # For each question
      questions.each_with_index do |question, index|
        @screen_mock.expect(:show_question, nil, [index + 1, question])
        @input_reader_mock.expect(:read, "2 3", [:space_separated])
        @validator_mock.expect(:correct?, true, ["2 3", question])
        @screen_mock.expect(:show_correct, nil)
      end

      @timer_mock.expect(:stop, nil)
      @timer_mock.expect(:elapsed, 10.5)
      @screen_mock.expect(:show_result, nil, [10.5])

      # This block is empty because we're just setting up expectations
    end
  end
end
