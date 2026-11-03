# vercmp

## 概要

ドット区切りの数値バージョン（長さ不定）を比べて、`<` `=` `>` を出す


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
dist/vercmp 1.2 1.10
<
dist/vercmp 1.2 1.2.0
=
```

```bash
node dist/vercmp_js/main.mjs 2 1.9.9.9
>
```
