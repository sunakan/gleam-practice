# nginx_accesslog

## 概要

nginx のアクセスログ（LTSV 形式）を読み、HTTP メソッドとステータスの組ごとに件数を数える


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
dist/nginx_accesslog testdata/access.log
17 POST 200
6 GET 200
5 POST 400
3 GET 403
3 GET 499
3 POST 404
2 GET 404
2 POST 401
2 POST 499
1 GET 401
skipped: 0
```

```bash
node dist/nginx_accesslog_js/main.mjs testdata/access.log
```

## 入力

LTSV（タブ区切りの `key:value`）の 1 行から `method` と `status` を使う。
どちらかが無い行や、`status` が整数でない行は、壊れた行として数えてスキップする（`skipped`）。

## ドキュメント

```bash
mise build-docs
```

```bash
open dist/nginx_accesslog_docs/index.html
```
