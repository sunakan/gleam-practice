import gleam/result
import gleam/time/duration
import gleeunit
import mysql_slowquerylog_duration as slowlog
import mysql_slowquerylog_duration/period

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn format_duration_zero_test() {
  assert slowlog.format_duration(duration.seconds(0)) == "0s"
}

pub fn format_duration_seconds_test() {
  assert slowlog.format_duration(duration.seconds(59)) == "59s"
}

pub fn format_duration_minutes_test() {
  assert slowlog.format_duration(duration.seconds(77)) == "1m17s"
}

pub fn format_duration_hour_with_zeros_test() {
  assert slowlog.format_duration(duration.seconds(3600)) == "1h0m0s"
}

pub fn format_duration_hours_test() {
  assert slowlog.format_duration(duration.seconds(3661)) == "1h1m1s"
}

pub fn format_duration_truncates_subsecond_test() {
  assert slowlog.format_duration(duration.milliseconds(1999)) == "1s"
}

pub fn summarize_basic_test() {
  let lines = [
    "/usr/sbin/mysqld, Version: 8.4.10 (Ubuntu). started with:",
    "# Time: 2026-10-03T07:40:43.106011Z",
    "# User@Host: isucon[isucon] @ localhost [127.0.0.1]  Id:     8",
    "SELECT 1;",
    "# Time: 2026-10-03T07:40:56.718644Z",
    "SELECT 2;",
  ]
  let assert Ok(#(p, entries, skipped)) = slowlog.summarize(lines)
  assert entries == 2
  assert skipped == 0
  assert duration.to_seconds_and_nanoseconds(period.duration(p))
    == #(13, 612_633_000)
}

pub fn summarize_unordered_test() {
  let lines = [
    "# Time: 2026-10-03T07:00:10Z",
    "# Time: 2026-10-03T07:00:00Z",
    "# Time: 2026-10-03T07:00:30Z",
  ]
  let assert Ok(#(p, entries, skipped)) = slowlog.summarize(lines)
  assert entries == 3
  assert skipped == 0
  assert duration.to_seconds_and_nanoseconds(period.duration(p)) == #(30, 0)
}

pub fn summarize_single_entry_test() {
  let lines = ["# Time: 2026-10-03T07:00:00Z"]
  let assert Ok(#(p, entries, _)) = slowlog.summarize(lines)
  assert entries == 1
  assert duration.to_seconds_and_nanoseconds(period.duration(p)) == #(0, 0)
}

pub fn summarize_skips_unreadable_time_test() {
  let lines = [
    "# Time: not-a-time",
    "# Time: 2026-10-03T07:00:00Z",
    "# Time: 2026-10-03T07:00:05Z",
  ]
  let assert Ok(#(_, entries, skipped)) = slowlog.summarize(lines)
  assert entries == 2
  assert skipped == 1
}

pub fn summarize_ignores_time_in_sql_test() {
  let lines = ["SELECT '# Time: x';", "# Time: 2026-10-03T07:00:00Z"]
  let assert Ok(#(_, entries, skipped)) = slowlog.summarize(lines)
  assert entries == 1
  assert skipped == 0
}

pub fn summarize_no_entries_test() {
  assert result.is_error(slowlog.summarize(["SELECT 1;"]))
}

pub fn summarize_no_readable_entries_test() {
  assert result.is_error(slowlog.summarize(["# Time: not-a-time"]))
}
