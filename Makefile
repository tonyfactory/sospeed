.PHONY: build run test help

# Dockerイメージをビルド
build:
	docker build -t sospeed .

# ゲームを実行（Docker）
# 使用例: make run ARGS="--level 2 --questions 10"
run:
	docker run --rm -it sospeed $(ARGS)

# ゲームを実行（ローカル）
# 使用例: make run-local ARGS="--level 2 --questions 10"
run-local:
	ruby bin/sospeed $(ARGS)

# 全てのテストを実行
test:
	ruby -I lib -e "Dir.glob('test/**/**/test_*.rb').sort.each { |file| load file }"

# テストを実行（単一ファイル指定）
# 使用例: make test-file FILE=test/test_difficulty.rb
test-file:
	ruby -I lib:test $(FILE)

# ヘルプを表示
help:
	@echo "利用可能なコマンド:"
	@echo "  make build       - Dockerイメージをビルド"
	@echo "  make run         - Docker環境でゲームを実行"
	@echo "                     例: make run ARGS=\"--level 2 --questions 10\""
	@echo "  make run-local   - ローカル環境でゲームを実行"
	@echo "                     例: make run-local ARGS=\"--level 2 --questions 10\""
	@echo "  make test        - 全テストを実行"
	@echo "  make test-file FILE=<path> - 指定したテストファイルを実行"
