import gleam/dict.{type Dict}

/// LTSVの1行(タブ区切りの`key:value`を解析する)
pub fn parse_line(line: String) -> Result(Dict(String, String), String) {
  todo
}
