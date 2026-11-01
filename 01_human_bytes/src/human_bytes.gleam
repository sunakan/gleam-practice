import gleam/float
import gleam/int
import gleam/result

// 文字列の連結: <>
// floatの処理は . をつける(/.とか)
pub fn format_bytes(bytes: Int) -> String {
  case bytes < 1024 {
    True -> int.to_string(bytes) <> " B"
    False -> scale(int.to_float(bytes) /. 1024.0, "KiB", ["MiB", "GiB"])
  }
}

// scaleは再帰関数
fn scale(value: Float, unit: String, rest: List(String)) -> String {
  case rest {
    [next, ..tail] if value >=. 1024.0 -> scale(value /. 1024.0, next, tail)
    _ -> float.to_string(float.to_precision(value, 1)) <> " " <> unit
  }
}

pub fn parse_bytes(input: String) -> Result(Int, String) {
  int.parse(input)
  |> result.map_error(fn(_) { "数値ではありません: " <> input })
  // 上と同じ
  // case int.parse(input) {
  //   Ok(bytes) -> Ok(bytes)
  //   Error(_) -> Error("数値ではありません: " <> input)
  // }
}
