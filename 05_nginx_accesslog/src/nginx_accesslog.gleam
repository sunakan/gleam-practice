import gleam/io

/// 行のリストを `#(メソッド, ステータス)` 毎に数える
/// 戻り値は、 `#(件数, メソッド, ステータス)` を件数の降順(同数ならメソッド、ステータスの昇順)
/// に並べたリストと壊れた行の数。空行は無視
pub fn tally(lines: List(String)) -> #(List(#(Int, String, Int)), Int) {
  todo
}

pub fn main() -> Nil {
  io.println("Hello from nginx_accesslog!")
}
