import argv
import gleam/int
import gleam/io
import gleam/list
import gleam/order.{type Order}
import gleam/result
import gleam/string

@external(erlang, "erlang", "halt")
@external(javascript, "./vercmp_ffi.mjs", "halt")
fn halt(code: Int) -> Nil

pub fn parse_version(input: String) -> Result(List(Int), String) {
  string.split(input, ".")
  |> list.try_map(fn(i) {
    case int.parse(i) {
      Ok(n) if n >= 0 -> Ok(n)
      _ -> Error(Nil)
    }
  })
  |> result.replace_error("不正なバージョン: " <> input)
}

pub fn compare(a: List(Int), b: List(Int)) -> Order {
  case a, b {
    [], [] -> order.Eq
    [], _ -> compare([0], b)
    _, [] -> compare(a, [0])
    [x, ..rest1], [y, ..rest2] if x == y -> compare(rest1, rest2)
    [x, ..], [y, ..] -> int.compare(x, y)
  }
}

fn fail(message: String) -> Nil {
  io.println_error(message)
  halt(1)
}

fn symbol(order: Order) -> String {
  case order {
    order.Lt -> "<"
    order.Eq -> "="
    order.Gt -> ">"
  }
}

pub fn main() -> Nil {
  case argv.load().arguments {
    [a, b] -> {
      case parse_version(a), parse_version(b) {
        Ok(va), Ok(vb) -> io.println(symbol(compare(va, vb)))
        Error(message), _ -> fail(message)
        _, Error(message) -> fail(message)
      }
    }
    _ -> fail("使い方: vercmp <a> <b>")
  }
}
