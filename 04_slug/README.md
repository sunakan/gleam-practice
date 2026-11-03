# slug

## 概要

文章を URL に使える slug（小文字の英数字をハイフンでつないだ文字列）に変える


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
dist/slug 'Hello, World!'
hello-world
dist/slug Gleam is   fun
gleam-is-fun
```

```bash
node dist/slug_js/main.mjs 'Hello, World! 2026'
hello-world-2026
```

## ドキュメント

```bash
mise build-docs
```

```bash
open dist/slug_docs/index.html
```
