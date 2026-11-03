import gleam/result
import gleam/list
import argv
import ipv4_parse_with_pbt/ipv4
import gleam/io

@external(erlang, "erlang", "halt")
@external(javascript, "./ipv4_parse_with_pbt_ffi.mjs", "halt")
fn halt(code: Int) -> Nil

fn fail(message) -> Nil {
  io.println_error(message)
  halt(1)
}

pub fn main() -> Nil {
  case argv.load().arguments {
    [] -> fail("使い方: ipv4_parse_with_pbt <Ipv4アドレス>...")
    args -> {
      list.each(args, fn(arg) {
        io.println(format_line(arg))
      })
      case list.any(args, fn(arg) { ipv4.parse(arg) |> result.is_error }) {
        True -> halt(2)
        False -> Nil
      }
    }
  }
}

pub fn format_line(arg: String) -> String {
  case ipv4.parse(arg) {
    Ok(_) -> arg <> " ok"
    Error(e) -> arg <> " error: " <> ipv4.error_to_string(e)
  }
}
