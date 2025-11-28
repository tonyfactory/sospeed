# SoSpeed - 素因数分解スピードゲーム

特定の数値の素因数分解をなるべく早く行うスピードゲームです。

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
   ruby bin/sospeed

   # テストを実行
   make test
   ```

### ローカル環境で実行する場合

#### 必要なもの
- Ruby 3.3以上

#### セットアップ
```bash
# 依存gemのインストール（テスト実行に必要）
bundle install
```

#### 実行方法
```bash
# 標準モード
ruby bin/sospeed

# レベル指定
ruby bin/sospeed --level 3

# 入力モード指定
ruby bin/sospeed --mode 2

# 問題数指定（裏モード）
ruby bin/sospeed --questions 10

# ヘルプ表示
ruby bin/sospeed --help
```

#### テスト実行
```bash
# 全テストを実行
make test

# 特定のテストファイルを実行
make test-file FILE=test/test_difficulty.rb
```

### Docker で実行する場合

#### Makefile を使う場合（推奨）
```bash
# イメージをビルド
make build

# 標準モード（対話形式）
make run
```

#### docker コマンドを直接使う場合
```bash
# イメージビルド
docker build -t sospeed .

# 標準モード（対話形式）
docker run --rm -it sospeed

# オプション指定
docker run --rm -it sospeed --level 3 --mode 2
docker run --rm -it sospeed --questions 10
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

## ライセンス

MIT License
