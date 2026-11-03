import argv
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

@external(erlang, "erlang", "halt")
@external(javascript, "./stats_ffi.mjs", "halt")
fn halt(code: Int) -> Nil

pub type Summary {
  Summary(count: Int, sum: Int, min: Int, max: Int, mean: Float, median: Float)
}

// Gleamにはreturn(早期リターン)がない
// 似たやつとして、result.tryがある(Rustでいう?みたいなやつ)
//
// use min <- result.try(list.first(sorted))は以下の糖衣構文
// case list.first(sorted) {
//   Ok(min) -> {
//     // 取得できた時の処理(どんどん入れ子になっていく)
//   }
//   Error(_) -> Error(Nil)
// }
pub fn summarize(numbers: List(Int)) -> Result(Summary, Nil) {
  let sorted = list.sort(numbers, int.compare)
  use min <- result.try(list.first(sorted))
  use max <- result.try(list.last(sorted))
  let count = list.length(sorted)
  let sum = int.sum(sorted)
  let middle =
    sorted
    |> list.drop({ count - 1 } / 2)
    |> list.take(2 - count % 2)

  Ok(Summary(
    count: count,
    sum: sum,
    min: min,
    max: max,
    mean: int.to_float(sum) /. int.to_float(count),
    median: int.to_float(int.sum(middle)) /. int.to_float(list.length(middle)),
  ))
}

pub fn parse_numbers(args: List(String)) -> Result(List(Int), String) {
  list.try_map(args, fn(arg) {
    int.parse(arg) |> result.replace_error("数値ではありません: " <> arg)
  })
}

pub fn format_summary(summary: Summary) -> String {
  string.join(
    [
      "count: " <> int.to_string(summary.count),
      "sum: " <> int.to_string(summary.sum),
      "min: " <> int.to_string(summary.min),
      "max: " <> int.to_string(summary.max),
      "mean: " <> format_float(summary.mean),
      "median: " <> format_float(summary.median),
    ],
    "\n",
  )
}

fn format_float(value: Float) -> String {
  float.to_string(float.to_precision(value, 1))
}

fn fail(message: String) -> Nil {
  io.println_error(message)
  halt(1)
}

pub fn main() -> Nil {
  case parse_numbers(argv.load().arguments) {
    Error(message) -> fail(message)
    Ok(numbers) ->
      case summarize(numbers) {
        Ok(summary) -> io.println(format_summary(summary))
        Error(_) -> fail("使い方: stats <整数>...")
      }
  }
}
