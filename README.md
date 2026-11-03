# gleam-practice

Gleam で小さな CLI を作りながら、関数型・Elixir・Erlang・BEAM・OTP を段階的に学ぶリポジトリ
1つのディレクトリ:1つの独立したGleamプロジェクト（`NN_name/`）

## プロジェクトと学習内容

| プロジェクト | 内容 | 学習 |
|---|---|---|
| [`01_human_bytes`](01_human_bytes) | バイト数を `1.5 KiB` のように整形する | `Int` と `Float` の演算子の違い、文字列の連結、`Result`、escript、単体テスト |
| [`02_stats`](02_stats) | 整数の列から件数・合計・最小・最大・平均・中央値を出す | `List` の操作（`map` / `fold` / `sort`）、カスタム型、`use` と `Result` の連鎖 |
| [`03_vercmp`](03_vercmp) | ドット区切りの数値バージョンを比べる | パターンマッチング（リスト・複数の値）、ガード、再帰 |
| [`04_slug`](04_slug) | 文章を URL 用の slug に変える | 高階関数、関数キャプチャ、パイプライン、書記素、ドキュメントコメント |
| [`05_nginx_accesslog`](05_nginx_accesslog) | nginx のアクセスログ（LTSV）を `(メソッド, ステータス)` ごとに数える | `dict`・タプル、モジュールの分割、ファイルの読み込み、多段の並べ替え |
| [`06_mysql_slowquerylog_duration`](06_mysql_slowquerylog_duration) | MySQL のスロークエリログの期間を出す | opaque 型、日付と時間 |

言語の基本（型・関数・パターンマッチング・コレクション・文字列・モジュール・日付と時間）は、ここまでで一巡している。

## 各プロジェクトの共通構成

各プロジェクトは独立していて、次のファイルを持つ

- `mise.toml`: erlang と gleam の版を固定
- `mise-tasks/test`: 単体テスト（`mise run test`）
- `mise-tasks/build`: escript・erlang-shipment・JS（Node 用の入口 `main.mjs` 付き）を `dist/` に出力
- `mise-tasks/build-docs`: `gleam docs build` の結果を `dist/<name>_docs/` にコピー
- `mise-tasks/e2e`: `dist/<name>` を実際に叩いて、標準出力・標準エラー・終了コードを検証

## 新しいプロジェクトの作り方

```bash
mkdir 07_name && cd 07_name
mise use erlang@29.1.2 gleam@1.19.2
gleam new . --name name
cd ..
mise run setup
```

`mise run setup`（ルートの `mise-tasks/setup`）は、`.gitignore` と `mise-tasks/` の雛形を全プロジェクトに用意する。既存のファイルは上書きしない（冪等）。
