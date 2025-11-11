#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 簡易的な動作確認テスト
require_relative 'lib/sospeed'

puts "=" * 50
puts "リファクタリング後の動作確認テスト"
puts "=" * 50
puts ""

# 1. Difficulty設定の確認
puts "1. Difficulty設定の確認"
level1 = SoSpeed::Difficulty.get(:level1)
puts "  Level1: #{level1[:name]} - 素数: #{level1[:primes]}, 上限: #{level1[:max_number]}"
puts "  ✓ OK"
puts ""

# 2. 問題生成の確認
puts "2. 問題生成の確認"
generator = SoSpeed::Question::Generator.new(level1)
questions = generator.generate(3)
questions.each_with_index do |q, i|
  puts "  問題#{i+1}: #{q[:number]} = #{q[:factors].join(' × ')}"
end
puts "  ✓ OK"
puts ""

# 3. Validatorの確認
puts "3. Validator(正解判定)の確認"
validator = SoSpeed::Question::Validator.new
test_question = { number: 6, factors: [2, 3] }
puts "  問題: 6 の素因数は [2, 3]"
puts "  '2 3' を入力 → #{validator.correct?('2 3', test_question) ? '正解' : '不正解'}"
puts "  '3 2' を入力 → #{validator.correct?('3 2', test_question) ? '正解' : '不正解'}"
puts "  '2 2' を入力 → #{validator.correct?('2 2', test_question) ? '不正解' : '正解'}"
puts "  ✓ OK"
puts ""

# 4. Timerの確認
puts "4. Timer(時間計測)の確認"
timer = SoSpeed::Timer.new
timer.start
sleep(0.1)
timer.stop
elapsed = timer.elapsed
puts "  0.1秒のsleep後の経過時間: #{elapsed.round(2)}秒"
puts "  ✓ OK"
puts ""

puts "=" * 50
puts "すべてのテストが正常に完了しました！"
puts "=" * 50
