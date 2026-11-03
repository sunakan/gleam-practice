import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/order
import gleam/result
import gleam/string
import nginx_accesslog/ltsv

// break_tieは、同順位(tie)の時、次の基準で決めるための関数
/// 行のリストを `#(メソッド, ステータス)` 毎に数える
/// 戻り値は、 `#(件数, メソッド, ステータス)` を件数の降順(同数ならメソッド、ステータスの昇順)
/// に並べたリストと壊れた行の数。空行は無視
pub fn tally(lines: List(String)) -> #(List(#(Int, String, Int)), Int) {
  let #(entries, errors) =
    lines
    |> list.filter(fn(line) { line != "" })
    |> list.map(parse_entry)
    |> result.partition
  let entry_and_counts =
    entries
    |> list.fold(dict.new(), fn(entry_n_counts, entry) {
      dict.upsert(entry_n_counts, entry, fn(current) {
        case current {
          Some(n) -> n + 1
          None -> 1
        }
      })
    })
    |> dict.to_list
    |> list.map(fn(pair) {
      let #(#(method, status), count) = pair
      #(count, method, status)
    })
    |> list.sort(fn(a, b) {
      let #(count_a, method_a, status_a) = a
      let #(count_b, method_b, status_b) = b
      int.compare(count_b, count_a)
      |> order.break_tie(string.compare(method_a, method_b))
      |> order.break_tie(int.compare(status_a, status_b))
    })
  let error_count = list.length(errors)
  #(entry_and_counts, error_count)
}

fn parse_entry(line: String) -> Result(#(String, Int), String) {
  use fields <- result.try(ltsv.parse_line(line))
  use method <- result.try(
    dict.get(fields, "method")
    |> result.replace_error("methodが見つかりませんでした(" <> line <> ")"),
  )
  use status_text <- result.try(
    dict.get(fields, "status")
    |> result.replace_error("statusが見つかりませんでした(" <> line <> ")"),
  )
  use status <- result.try(
    int.parse(status_text)
    |> result.replace_error("intへの変換に失敗しました(" <> status_text <> ")"),
  )
  Ok(#(method, status))
}

pub fn main() -> Nil {
  io.println("Hello from nginx_accesslog!")
}
