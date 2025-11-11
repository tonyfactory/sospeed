# -*- coding: utf-8 -*-

module SoSpeed
  class GameEngine
    DEFAULT_QUESTION_COUNT = 5

    def initialize(options = {})
      @difficulty = options[:difficulty]
      @input_mode = options[:input_mode]
      @question_count = options[:question_count] || DEFAULT_QUESTION_COUNT

      @screen = PlayerInterface::Screen.new
      @input_reader = PlayerInterface::InputReader.new
      @validator = Question::Validator.new
      @timer = Timer.new
    end

    def start
      setup_phase
      play_phase
      result_phase
    end

    private

    def setup_phase
      @screen.show_intro(@question_count)

      # 難易度選択（オプション指定がない場合のみ）
      @difficulty ||= @screen.select_difficulty

      # 操作方法選択（オプション指定がない場合のみ）
      @input_mode ||= @screen.select_input_mode

      @screen.show_start_prompt
    end

    def play_phase
      # 問題生成
      difficulty_settings = Difficulty.get(@difficulty)
      generator = Question::Generator.new(difficulty_settings)
      @questions = generator.generate(@question_count)

      # 計測開始
      @timer.start

      # 問題を順次解く
      @questions.each_with_index do |question, index|
        solve_question(question, index + 1)
      end

      # 計測終了
      @timer.stop
    end

    def solve_question(question, number)
      @screen.show_question(number, question)

      loop do
        # 入力読み取り
        answer = @input_reader.read(@input_mode)

        # 空白入力は無視
        next if answer.empty?

        # 正解判定
        if @validator.correct?(answer, question)
          @screen.show_correct
          break
        else
          @screen.show_incorrect
        end
      end
    end

    def result_phase
      @screen.show_result(@timer.elapsed)
    end
  end
end
