import argv
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "erlang", "halt")
@external(javascript, "./slug_ffi.mjs", "halt")
fn halt(code: Int) -> Nil

/// 文章を URL に使える slug に変換する。
/// 英数字以外の書記素は区切りとみなし、連続する区切りは `-` 1 つにまとめる。
pub fn slugify(input: String) -> String {
  input
  |> string.lowercase
  |> map_graphemes(replace_non_alphanumeric)
  |> collapse_separators
}

/// 受け取ったStringの1文字ずつに対して、関数を当て込んでJOINして返す
/// graphemeというのは、人が「1文字」と感じる単位
fn map_graphemes(text: String, f: fn(String) -> String) -> String {
  string.to_graphemes(text)
  |> list.map(f)
  |> string.join("")
}

const alphanumerics = "abcdefghijklmnopqrstuvwxyz0123456789"

fn replace_non_alphanumeric(grapheme: String) -> String {
  case string.contains(alphanumerics, grapheme) {
    True -> grapheme
    False -> "-"
  }
}

/// 連続した"-"を、"-"の1文字にする
fn collapse_separators(text: String) -> String {
  string.split(text, "-")
  |> list.filter(fn(s) { s != "" })
  |> string.join("-")
}

pub fn main() -> Nil {
  case argv.load().arguments {
    [] -> {
      io.println_error("使い方: slug <文章>...")
      halt(1)
    }
    arguments ->
      arguments
      |> string.join(" ")
      |> slugify
      |> io.println
  }
}
