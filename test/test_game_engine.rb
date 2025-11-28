# -*- coding: utf-8 -*-

require_relative 'test_helper'
require_relative '../lib/sospeed'

class TestGameEngine < Minitest::Test
  # 定数化
  MOCK_ELAPSED_TIME = 10.5
  MOCK_DIFFICULTY_SETTINGS = {
    name: "レベル1",
    primes: [2, 3, 5, 7],
    factor_count: (2..2),
    max_number: 50
  }.freeze
  MOCK_QUESTIONS = [
    { number: 6, factors: [2, 3] },
    { number: 10, factors: [2, 5] },
    { number: 14, factors: [2, 7] }
  ].freeze

  def setup
    @screen_mock = Minitest::Mock.new
    @input_reader_mock = Minitest::Mock.new
    @validator_mock = Minitest::Mock.new
    @timer_mock = Minitest::Mock.new
    @generator_mock = Minitest::Mock.new

    stub_constructors
  end

  def teardown
    restore_constructors
  end

  def test_start_with_predefined_options
    difficulty = :level1
    input_mode = :space_separated
    question_count = 3

    setup_common_expectations(question_count, input_mode, skip_selection: true)

    game_engine = SoSpeed::GameEngine.new(
      difficulty: difficulty,
      input_mode: input_mode,
      question_count: question_count
    )

    run_game_with_difficulty_stub(game_engine)
    verify_all_mocks
  end

  def test_start_with_user_selected_options
    question_count = 3
    input_mode = :space_separated

    @screen_mock.expect(:select_difficulty, :level1)
    @screen_mock.expect(:select_input_mode, input_mode)

    setup_common_expectations(question_count, input_mode, skip_selection: false)

    game_engine = SoSpeed::GameEngine.new(question_count: question_count)

    run_game_with_difficulty_stub(game_engine)
    verify_all_mocks
  end

  def test_start_with_incorrect_answer_then_correct
    question_count = 1
    input_mode = :space_separated

    @screen_mock.expect(:show_intro, nil, [question_count])
    @screen_mock.expect(:show_start_prompt, nil)

    question = { number: 6, factors: [2, 3] }

    SoSpeed::Difficulty.stub(:get, MOCK_DIFFICULTY_SETTINGS) do
      @generator_mock.expect(:generate, [question], [question_count])
      @timer_mock.expect(:start, nil)

      # 問題表示は1回のみ（ループ内で再表示されない）
      @screen_mock.expect(:show_question, nil, [1, question])

      # 1回目：不正解
      @input_reader_mock.expect(:read, "2 2", [input_mode])
      @validator_mock.expect(:correct?, false, ["2 2", question])
      @screen_mock.expect(:show_incorrect, nil)

      # 2回目：正解
      @input_reader_mock.expect(:read, "2 3", [input_mode])
      @validator_mock.expect(:correct?, true, ["2 3", question])
      @screen_mock.expect(:show_correct, nil)

      @timer_mock.expect(:stop, nil)
      @timer_mock.expect(:elapsed, MOCK_ELAPSED_TIME)
      @screen_mock.expect(:show_result, nil) do |elapsed, question_times|
        assert_equal MOCK_ELAPSED_TIME, elapsed
        assert_instance_of Array, question_times
        assert_equal question_count, question_times.size
        true
      end

      game_engine = SoSpeed::GameEngine.new(
        difficulty: :level1,
        input_mode: input_mode,
        question_count: question_count
      )

      game_engine.start
    end

    verify_all_mocks
  end

  private

  def stub_constructors
    @original_constructors = {}

    {
      'Screen' => [SoSpeed::PlayerInterface::Screen, @screen_mock],
      'InputReader' => [SoSpeed::PlayerInterface::InputReader, @input_reader_mock],
      'Validator' => [SoSpeed::Question::Validator, @validator_mock],
      'Timer' => [SoSpeed::Timer, @timer_mock],
      'Generator' => [SoSpeed::Question::Generator, @generator_mock]
    }.each do |name, (klass, mock)|
      @original_constructors[name] = klass.method(:new)
      klass.define_singleton_method(:new) { |*args| mock }
    end
  end

  def restore_constructors
    return unless @original_constructors

    [
      [SoSpeed::PlayerInterface::Screen, 'Screen'],
      [SoSpeed::PlayerInterface::InputReader, 'InputReader'],
      [SoSpeed::Question::Validator, 'Validator'],
      [SoSpeed::Timer, 'Timer'],
      [SoSpeed::Question::Generator, 'Generator']
    ].each do |klass, name|
      if @original_constructors[name]
        klass.define_singleton_method(:new, @original_constructors[name])
      end
    end
  ensure
    @original_constructors = nil
  end

  def setup_common_expectations(question_count, input_mode, skip_selection:)
    @screen_mock.expect(:show_intro, nil, [question_count])
    @screen_mock.expect(:show_start_prompt, nil)

    @generator_mock.expect(:generate, MOCK_QUESTIONS, [question_count])
    @timer_mock.expect(:start, nil)

    MOCK_QUESTIONS.take(question_count).each_with_index do |question, index|
      @screen_mock.expect(:show_question, nil, [index + 1, question])
      @input_reader_mock.expect(:read, "2 3", [input_mode])
      @validator_mock.expect(:correct?, true, ["2 3", question])
      @screen_mock.expect(:show_correct, nil)
    end

    @timer_mock.expect(:stop, nil)
    @timer_mock.expect(:elapsed, MOCK_ELAPSED_TIME)

    @screen_mock.expect(:show_result, nil) do |elapsed, question_times|
      assert_equal MOCK_ELAPSED_TIME, elapsed
      assert_instance_of Array, question_times
      assert_equal question_count, question_times.size
      true
    end
  end

  def run_game_with_difficulty_stub(game_engine)
    SoSpeed::Difficulty.stub(:get, MOCK_DIFFICULTY_SETTINGS) do
      game_engine.start
    end
  end

  def verify_all_mocks
    [@screen_mock, @input_reader_mock, @validator_mock, @timer_mock, @generator_mock].each(&:verify)
  end
end
