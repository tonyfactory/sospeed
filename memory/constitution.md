# SoSpeed プロジェクト憲章

## 技術スタック
- **言語**: Ruby 3.3（固定バージョン）
- **フレームワーク**: なし（標準ライブラリのみ使用）
- **テスティング**: Minitest 5.20以降、minitest-reporters 1.6以降
- **依存関係**: 標準ライブラリのみ（`set`, `io/console`）
- **実行環境**: ローカル（Ruby 3.3必須）またはDocker（Ruby 3.3-slim）

## コーディング規約
- **言語**: 対話やファイル作成はすべて日本語で行う
- **コメント**: 日本語で記述
- **文字エンコーディング**: UTF-8（各ファイルに`# -*- coding: utf-8 -*-`を記載）
- **frozen_string_literal**: 可能な限り`# frozen_string_literal: true`を使用
- **Gitコミットメッセージ**: 日本語、簡潔で明確な形式
  - 機能追加: 「〜を追加」
  - 変更: 「〜を変更」
  - 修正: 「〜を修正」
- **インデント**: スペース2つ
- **命名規則**:
  - クラス名: PascalCase（例: `GameEngine`, `InputReader`）
  - モジュール名: PascalCase（例: `SoSpeed`, `PlayerInterface`）
  - メソッド名: snake_case（例: `select_difficulty`, `show_question`）
  - 定数: SCREAMING_SNAKE_CASE（例: `DEFAULT_QUESTION_COUNT`, `ERROR_WAIT_TIME`）

## プロジェクト構成
```
sospeed/
├── bin/
│   └── sospeed                          # 実行スクリプト
├── lib/
│   ├── sospeed.rb                       # メインモジュール、VERSION定義
│   └── sospeed/
│       ├── difficulty.rb                # 難易度設定管理
│       ├── timer.rb                     # タイマー機能
│       ├── game_engine.rb               # ゲーム進行制御
│       ├── question/
│       │   ├── generator.rb            # 問題生成
│       │   └── validator.rb            # 正解判定
│       └── player_interface/
│           ├── screen.rb                # 画面表示
│           ├── input_reader.rb          # 入力読み取り
│           └── keyboard.rb              # キーボードマッピング
├── test/
│   ├── test_helper.rb                   # テストヘルパー
│   ├── test_difficulty.rb
│   ├── test_timer.rb
│   ├── test_game_engine.rb
│   ├── question/
│   │   ├── test_generator.rb
│   │   └── test_validator.rb
│   └── player_interface/
│       ├── test_screen.rb
│       ├── test_input_reader.rb
│       └── test_keyboard.rb
├── .devcontainer/                       # Dev Containers設定
│   ├── devcontainer.json
│   └── Dockerfile
├── Dockerfile                           # Ruby 3.3-slim環境
├── Gemfile                              # 開発・テスト用gem定義
└── Makefile                             # Docker操作用タスク定義
```

## 設計原則
### 1. 単一責任の原則（SRP）
- 各クラスは1つの明確な責任のみを持つ
- 例:
  - `GameEngine`: ゲーム進行フロー制御のみ
  - `Question::Generator`: 問題生成のみ
  - `Question::Validator`: 正解判定のみ
  - `PlayerInterface::Screen`: 画面表示のみ
  - `PlayerInterface::InputReader`: 入力読み取りのみ

### 2. 依存性の注入（DI）
- 外部依存は初期化時に注入可能にする
- コンストラクタでオプションハッシュを受け取る設計
- 例: `GameEngine.new(difficulty: :level1, input_mode: :space)`
- テスタビリティを向上させる

### 3. 標準ライブラリ優先
- 外部gemへの依存を最小限に抑える
- 開発・テスト環境以外では外部gemを使用しない
- `io/console`, `set`など標準ライブラリで実現可能な範囲で実装

### 4. モジュール分割
- 機能ごとに適切なネームスペースを設ける
- `SoSpeed::Question::*`: 問題関連
- `SoSpeed::PlayerInterface::*`: プレイヤー入出力関連
- `SoSpeed::*`: コア機能（難易度、タイマー、エンジン）

### 5. テスタビリティ
- すべてのクラスにユニットテストを記述
- Minitestを使用し、`test_helper.rb`で共通設定を管理
- テストファイルは`lib/`のディレクトリ構造に対応

## 制約事項
### 必須制約
1. **単一ファイル構成の廃止**: リファクタリング済み、モジュール分割構成を維持
2. **標準ライブラリのみ使用**: 実行環境では外部gemを使用しない
3. **Ruby 3.3必須**: 互換性はRuby 3.3以降のみ保証
4. **既存機能の保持**:
   - 難易度レベル1〜4の設定
   - スペース区切り/キーボード割り当ての2種類の入力方式
   - 5問固定（裏モードで問題数指定可能）
   - 誤答時2秒待機
   - 同一素因数の重複許可、問題間での数値重複禁止

### Git操作に関する制約
- **重要**: Claude CodeはGitコミット操作を実行しない
- コミットメッセージの提案のみを行う
- `git add`, `git commit`, `git push`などはユーザーが実行

### Docker実行に関する制約
- `docker run -it`でインタラクティブモードを使用すること
- Makefileを使用した実行を推奨: `make build` → `make run`
- DevContainer使用時はVSCodeで "Reopen in Container" を選択

## 開発ワークフロー
1. **機能追加・変更時**:
   - 該当するクラス・モジュールを特定
   - テストを先に記述（TDD推奨）
   - 実装
   - テスト実行で確認
   - コミットメッセージ案の提示（ユーザーがコミット実行）

2. **テスト実行**:
   - ローカル: `make test` または `ruby -Ilib:test test/test_*.rb`
   - Docker: `make build` → `docker run --rm sospeed ruby -Ilib:test test/test_*.rb`

3. **リファクタリング時**:
   - 既存テストが通ることを確認してから開始
   - 単一責任の原則を意識
   - 依存性注入の余地を確保

## ドキュメント
- **CLAUDE.md**: AI向けプロジェクトガイド（このファイルの参照元）
- **spec.md**: 詳細仕様書（人間向け）
- **memory/constitution.md**: このファイル（プロジェクト憲章）

## バージョン管理
- 現在のバージョン: 2.0.0（`lib/sospeed.rb`で定義）
- セマンティックバージョニングに従う
  - メジャー: 破壊的変更
  - マイナー: 機能追加（後方互換性あり）
  - パッチ: バグ修正
