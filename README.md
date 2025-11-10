# SoSpeed - 素数スピード練習プログラム

素数の掛け算で構成された数値を素因数分解するスピード練習プログラムです。

## 開発環境セットアップ

### Dev Containers を使用する場合（推奨）

1. **前提条件**
   - Docker Desktop がインストールされていること
   - VS Code がインストールされていること
   - VS Code の "Dev Containers" 拡張機能がインストールされていること

2. **起動方法**
   ```bash
   # VS Code でこのプロジェクトを開く
   code .

   # コマンドパレット (Cmd+Shift+P / Ctrl+Shift+P) を開いて
   # "Dev Containers: Reopen in Container" を選択
   ```

3. **初回起動時**
   - Dockerイメージのビルドが自動的に開始されます
   - `bundle install` が自動実行されます
   - 完了後、コンテナ内のターミナルが開きます

4. **プログラムの実行**
   ```bash
   # コンテナ内で実行
   ruby sospeed.rb
   ```

### ローカル環境で実行する場合

#### 必要なもの
- Ruby 3.3以上

#### 実行方法
```bash
# 標準モード
ruby sospeed.rb

# レベル指定
ruby sospeed.rb --level 3

# 入力モード指定
ruby sospeed.rb --mode 2

# 問題数指定（裏モード）
ruby sospeed.rb --questions 10

# ヘルプ表示
ruby sospeed.rb --help
```

### Docker Compose で実行する場合

```bash
docker compose run --rm sospeed
```

## ゲームルール

- 表示された数字を素因数分解してください
- 素数をスペース区切りで入力してください（例: 2 3 5）
- 順序は問いません
- 5問すべて解くまでの時間を計測します

## 難易度

| レベル | 素数 | 個数 | 上限 |
|--------|------|------|------|
| 1 | 2,3,5,7 | 2個 | 50 |
| 2 | 2,3,5,7 | 3個 | 500 |
| 3 | 2,3,5,7,11 | 4個 | 1000 |
| 4 | 2,3,5,7,11 | 4〜5個 | 10000 |

## 入力方式

### 1. スペース区切り入力方式
- 素因数を半角スペース区切りで入力
- 例: `2 3 5` と入力してEnterキーで確定

### 2. キーボード割り当て方式
- キーボードに素数を割り当て
- `a`:2  `s`:3  `d`:5  `f`:7  `g`:11
- キーを押すと数字が表示され、Enterで確定
- Backspaceで削除可能

## 開発

### テスト実行
```bash
# Dev Container内、またはローカルで
bundle exec ruby -Ilib:test test/test_*.rb
```

### ファイル構成
```
sospeed/
├── .devcontainer/          # Dev Containers設定
│   ├── devcontainer.json
│   └── Dockerfile
├── lib/                    # ソースコード
│   └── sospeed/
├── test/                   # テストコード
├── sospeed.rb              # メインプログラム
├── Gemfile                 # Ruby依存関係
├── Dockerfile              # 実行用Dockerイメージ
├── docker-compose.yml      # Docker Compose設定
└── README.md               # このファイル
```

## ライセンス

MIT License
