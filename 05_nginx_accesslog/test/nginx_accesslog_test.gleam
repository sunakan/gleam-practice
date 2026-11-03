import gleeunit
import nginx_accesslog

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn tally_counts_test() {
  let lines = [
    "method:GET\tstatus:200",
    "method:POST\tstatus:500",
    "method:GET\tstatus:200",
  ]
  assert nginx_accesslog.tally(lines)
    == #([#(2, "GET", 200), #(1, "POST", 500)], 0)
}

pub fn tally_tie_break_test() {
  let lines = [
    "method:POST\tstatus:401",
    "method:GET\tstatus:404",
    "method:GET\tstatus:403",
  ]
  assert nginx_accesslog.tally(lines)
    == #([#(1, "GET", 403), #(1, "GET", 404), #(1, "POST", 401)], 0)
}

pub fn tally_skips_missing_status_test() {
  assert nginx_accesslog.tally(["method:GET"]) == #([], 1)
}

pub fn tally_skips_non_integer_status_test() {
  assert nginx_accesslog.tally(["method:GET\tstatus:abc"]) == #([], 1)
}

pub fn tally_skips_field_without_colon_test() {
  assert nginx_accesslog.tally(["method:GET\tstatus:200\tbroken"]) == #([], 1)
}

pub fn tally_ignores_blank_lines_test() {
  let lines = ["", "method:GET\tstatus:200", ""]
  assert nginx_accesslog.tally(lines) == #([#(1, "GET", 200)], 0)
}

pub fn tally_empty_test() {
  assert nginx_accesslog.tally([]) == #([], 0)
}
