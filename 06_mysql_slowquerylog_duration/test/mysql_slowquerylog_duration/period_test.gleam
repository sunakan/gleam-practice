import gleam/result
import gleam/time/duration
import gleam/time/timestamp
import mysql_slowquerylog_duration/period

pub fn new_ok_test() {
  let start = timestamp.from_unix_seconds(100)
  let end = timestamp.from_unix_seconds(200)
  let assert Ok(p) = period.new(start, end)
  assert period.start(p) == start
  assert period.end(p) == end
  assert duration.to_seconds_and_nanoseconds(period.duration(p)) == #(100, 0)
}

pub fn new_same_time_test() {
  let at = timestamp.from_unix_seconds(100)
  let assert Ok(p) = period.new(at, at)
  assert duration.to_seconds_and_nanoseconds(period.duration(p)) == #(0, 0)
}

pub fn new_end_before_start_test() {
  let start = timestamp.from_unix_seconds(200)
  let end = timestamp.from_unix_seconds(100)
  assert result.is_error(period.new(start, end))
}
