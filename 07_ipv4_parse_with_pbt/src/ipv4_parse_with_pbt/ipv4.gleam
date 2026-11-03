import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub opaque type Ipv4 {
  Ipv4(a: Int, b: Int, c: Int, d: Int)
}

pub type Ipv4Error {
  WrongOctetCount(Int)
  EmptyOctet
  NotANumber(String)
  LeadingZero(String)
  OutOfRange(Int)
}

pub fn parse(input: String) -> Result(Ipv4, Ipv4Error) {
  case string.split(input, ".") {
    [a, b, c, d] -> {
      use a <- result.try(parse_octet(a))
      use b <- result.try(parse_octet(b))
      use c <- result.try(parse_octet(c))
      use d <- result.try(parse_octet(d))
      from_octets(a, b, c, d)
    }
    parts -> Error(WrongOctetCount(list.length(parts)))
  }
}

// 判定
// - 空文字ではない
// - 全て数字
// - 2桁以上の場合、0始まりではない
// - intにしたとき、0以上255以下
fn parse_octet(octet: String) -> Result(Int, Ipv4Error) {
  use <- bool.guard(when: octet == "", return: Error(EmptyOctet))
  use <- bool.guard(
    when: string.to_graphemes(octet)
      |> list.any(fn(g) { !string.contains("0123456789", g) }),
    return: Error(NotANumber(octet)),
  )
  use <- bool.guard(
    when: 2 <= string.length(octet) && string.starts_with(octet, "0"),
    return: Error(LeadingZero(octet)),
  )
  case int.parse(octet) {
    Ok(n) if n <= 255 -> Ok(n)
    Ok(n) -> Error(OutOfRange(n))
    Error(Nil) -> Error(NotANumber(octet))
    // 上でチェックしているので、到達しない
  }
}

pub fn from_octets(a: Int, b: Int, c: Int, d: Int) -> Result(Ipv4, Ipv4Error) {
  case list.find([a, b, c, d], fn(octet) { octet < 0 || 255 < octet }) {
    Ok(n) -> Error(OutOfRange(n))
    Error(Nil) -> Ok(Ipv4(a, b, c, d))
  }
}

pub fn to_string(ip: Ipv4) -> String {
  let a = int.to_string(ip.a)
  let b = int.to_string(ip.b)
  let c = int.to_string(ip.c)
  let d = int.to_string(ip.d)
  string.join([a, b, c, d], ".")
}

pub fn octets(ip: Ipv4) -> #(Int, Int, Int, Int) {
  #(ip.a, ip.b, ip.c, ip.d)
}

pub fn error_to_string(error: Ipv4Error) -> String {
  case error {
    WrongOctetCount(n) -> "要素の数が4ではありません(" <> int.to_string(n) <> ")"
    EmptyOctet -> "空の要素があります"
    NotANumber(s) -> "数字ではありません: " <> s
    LeadingZero(s) -> "先頭に0があります: " <> s
    OutOfRange(n) -> "範囲外です: " <> int.to_string(n)
  }
}
