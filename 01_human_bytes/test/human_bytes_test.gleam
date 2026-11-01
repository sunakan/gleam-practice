import gleam/result
import gleeunit

// Gleamでは他のモジュールの関数を使うにはimportが必須
// この辺はGoに似ている(他言語でもimport必須は結構ある)
import human_bytes

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn format_bytes_zero_test() {
  assert human_bytes.format_bytes(0) == "0 B"
}

pub fn format_bytes_1023_test() {
  assert human_bytes.format_bytes(1023) == "1023 B"
}

pub fn format_bytes_1024_test() {
  assert human_bytes.format_bytes(1024) == "1.0 KiB"
}

// 1.5*1024 = 1,536
pub fn format_bytes_1536_test() {
  assert human_bytes.format_bytes(1536) == "1.5 KiB"
}

// 1*1024*1024 = 1,048,576
pub fn format_bytes_1_mib_test() {
  assert human_bytes.format_bytes(1_048_576) == "1.0 MiB"
}

// 1*1024*1024*1024 = 1,073,741,824
pub fn format_bytes_1_gib_test() {
  assert human_bytes.format_bytes(1_073_741_824) == "1.0 GiB"
}

pub fn parse_bytes_ok_test() {
  assert human_bytes.parse_bytes("1024") == Ok(1024)
}

pub fn parse_bytes_error_test() {
  assert result.is_error(human_bytes.parse_bytes("abc"))
}
