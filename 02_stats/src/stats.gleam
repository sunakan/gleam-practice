import gleam/int
import gleam/result
import gleam/list
import gleam/io

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
  |> list.drop({count - 1} / 2)
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

pub fn main() -> Nil {
  io.println("Hello from stats!")
}
