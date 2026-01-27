# Ruby 4.0の公式イメージを使用
FROM ruby:4.0-slim

# 日本語ロケールを設定
ENV LANG=ja_JP.UTF-8 \
    LC_ALL=ja_JP.UTF-8

# 作業ディレクトリを設定
WORKDIR /app

# アプリケーションファイルをコピー
COPY lib ./lib
COPY bin ./bin

# スクリプトに実行権限を付与
RUN chmod +x bin/sospeed

# エントリーポイント（コマンドライン引数を受け取れるように）
ENTRYPOINT ["ruby", "bin/sospeed"]
