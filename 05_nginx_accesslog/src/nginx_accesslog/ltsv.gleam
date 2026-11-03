import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/string

// list.try_map(fn(i) { string.split_once(i, ":") })
// list.try_map(string.split_once(_, ":"))
// 上記は同じ意味(_を利用するやつを、関数キャプチャと呼ぶ)
/// LTSVの1行(タブ区切りの`key:value`を解析する)
pub fn parse_line(line: String) -> Result(Dict(String, String), String) {
  string.split(line, "\t")
  |> list.try_map(string.split_once(_, ":"))
  |> result.replace_error("LTSV形式ではない行が含まれています(" <> line <> ")")
  |> result.map(dict.from_list)
}
