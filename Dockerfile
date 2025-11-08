# Ruby 3.3の公式イメージを使用
FROM ruby:3.3-slim

# 作業ディレクトリを設定
WORKDIR /app

# アプリケーションファイルをコピー
COPY sospeed.rb .

# スクリプトに実行権限を付与
RUN chmod +x sospeed.rb

# デフォルトコマンド
CMD ["ruby", "sospeed.rb"]
