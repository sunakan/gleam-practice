import gleam/dict
import gleam/result
import nginx_accesslog/ltsv

pub fn parse_line_fields_test() {
  let assert Ok(fields) = ltsv.parse_line("method:GET\tstatus:200")
  assert dict.get(fields, "method") == Ok("GET")
  assert dict.get(fields, "status") == Ok("200")
}

pub fn parse_line_value_with_colon_test() {
  let assert Ok(fields) =
    ltsv.parse_line("time:17/Oct/2026:04:45:50 +0000\tmethod:GET")
  assert dict.get(fields, "time") == Ok("17/Oct/2026:04:45:50 +0000")
  assert dict.get(fields, "method") == Ok("GET")
}

pub fn parse_line_empty_value_test() {
  let assert Ok(fields) = ltsv.parse_line("referer:-\tcache:")
  assert dict.get(fields, "referer") == Ok("-")
  assert dict.get(fields, "cache") == Ok("")
}

pub fn parse_line_without_colon_test() {
  assert result.is_error(ltsv.parse_line("method:GET\tbroken"))
}

pub fn parse_line_empty_test() {
  assert result.is_error(ltsv.parse_line(""))
}
