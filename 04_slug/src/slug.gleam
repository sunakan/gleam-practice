import gleam/io

/// 文章を URL に使える slug に変換する。
/// 英数字以外の書記素は区切りとみなし、連続する区切りは `-` 1 つにまとめる。
pub fn slugify(input: String) -> String {
  todo
}

pub fn main() -> Nil {
  io.println("Hello from slug!")
}
