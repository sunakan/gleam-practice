# stats

## 概要

整数の列から、件数・合計・最小・最大・平均・中央値を出す


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
dist/stats 3 1 4 1 5
count: 5
sum: 14
min: 1
max: 5
mean: 2.8
median: 3.0
```

```bash
node dist/stats_js/main.mjs 1 2 3 4
count: 4
sum: 10
min: 1
max: 4
mean: 2.5
median: 2.5
```
