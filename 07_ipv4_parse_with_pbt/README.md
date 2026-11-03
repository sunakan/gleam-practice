# ipv4_parse_with_pbt

## 概要

IPv4 アドレスの文字列を検証し、引数ごとに `ok` か `error: <理由>` を出す。
エラーは `Ipv4Error`（要素数・空・数字以外・先頭の 0・範囲外）で、左の要素から先に判定する。

## テスト

```bash
mise test
```

`qcheck` によるプロパティテスト（往復・範囲外・要素数）を含む。

```bash
mise e2e
```

## ビルドと実行

```bash
mise build
```

```bash
dist/ipv4_parse_with_pbt 192.168.0.1 1.2.3.256
192.168.0.1 ok
1.2.3.256 error: 範囲外です: 256
```

```bash
node dist/ipv4_parse_with_pbt_js/main.mjs 192.168.0.1
```

## 終了コード

| コード | 意味 |
|---|---|
| 0 | 全部が有効 |
| 1 | 引数なし（使い方を標準エラーに出す） |
| 2 | 1 つでも不正（全部出力した後に終了する） |

## ドキュメント

```bash
mise build-docs
```

```bash
open dist/ipv4_parse_with_pbt_docs/index.html
```
