.PHONY: up down restart build logs clean run test test_refactoring bash claude

# コンテナをバックグラウンドで起動
up:
	docker compose up -d

# コンテナを停止・削除
down:
	docker compose down

# コンテナを再起動
restart: down up

# イメージをビルド
build:
	docker compose build

# ログを表示
logs:
	docker compose logs -f

# コンテナを停止してイメージ・ボリュームも削除
clean:
	docker compose down -v --rmi all

# ゲームを実行（コンテナ内で）
run:
	@docker compose up -d 2>/dev/null || true
	@sleep 1
	docker compose exec -it sospeed ruby bin/sospeed

# 単一のリファクタリングテストを実行
test_refactoring:
	ruby test_refactoring.rb

# 全てのテストを実行
test:
	ruby -I lib -e "Dir.glob('test/**/**/test_*.rb').sort.each { |file| load file }"

# コンテナ内でbashを起動
bash:
	@docker compose up -d 2>/dev/null || true
	@sleep 1
	docker compose exec sospeed bash

# コンテナ内でClaude Codeを起動
claude:
	@docker compose up -d 2>/dev/null || true
	@sleep 1
	docker compose exec sospeed claude
