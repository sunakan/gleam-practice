# mysql_slowquerylog_duration

## 概要

MySQL のスロークエリログを読み、記録されている期間（最初の時刻から最後の時刻まで）を出す


## テスト

```bash
mise test
```

```bash
mise e2e
```

## ビルドと実行

```bash
mise build
```

```bash
dist/mysql_slowquerylog_duration testdata/slow.log
entries: 30
start: 2026-10-03T07:40:43.106011Z
end: 2026-10-03T07:40:56.718644Z
duration: 13s
skipped: 0
```

```bash
node dist/mysql_slowquerylog_duration_js/main.mjs testdata/slow.log
```

## 入力

`# Time: 2026-10-03T07:40:43.106011Z` の行（ISO 8601）を、エントリの区切りとして使う。
時刻が読めないエントリは、壊れたエントリとして数えてスキップする（`skipped`）。
差分は、秒未満を切り捨てて `1h2m3s` / `2m3s` / `3s` の形で出す。

## ドキュメント

```bash
mise build-docs
```

```bash
open dist/mysql_slowquerylog_duration_docs/index.html
```
