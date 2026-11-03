import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/duration.{type Duration}
import gleam/time/timestamp
import mysql_slowquerylog_duration/period.{type Period}

pub fn format_duration(duration: Duration) -> String {
  let #(seconds, _) = duration.to_seconds_and_nanoseconds(duration)
  case seconds {
    s if s >= 3600 -> {
      let h = int.to_string(s / 3600) <> "h"
      let m = int.to_string(s % 3600 / 60) <> "m"
      let sec = int.to_string(s % 60) <> "s"
      h <> m <> sec
    }
    s if s >= 60 -> {
      let m = int.to_string(s / 60) <> "m"
      let sec = int.to_string(s % 60) <> "s"
      m <> sec
    }
    s -> {
      int.to_string(s) <> "s"
    }
  }
}

/// 戻り値は3要素のタプル
/// - 1つ目: Period(最小と最大の時刻から作った区間)
/// - 2つ目: 読めたエントリの数(list.length(parsed))
/// - 3つ目: 読めなかった # Time: 行の数(list.length(errors))
pub fn summarize(lines: List(String)) -> Result(#(Period, Int, Int), String) {
  let #(parsed, skipped) =
    lines
    |> list.filter(string.starts_with(_, "# Time: "))
    |> list.map(string.remove_prefix(_, "# Time: "))
    |> list.map(timestamp.parse_rfc3339)
    |> result.partition
  let sorted =
    parsed
    |> list.sort(timestamp.compare)
  case sorted {
    [] -> Error("有効なエントリがありません")
    [first, ..rest] -> {
      let last = list.last(rest) |> result.unwrap(first)
      use period <- result.try(period.new(first, last))
      let entry_count = list.length(sorted)
      let skipped_count = list.length(skipped)
      Ok(#(period, entry_count, skipped_count))
    }
  }
}

pub fn main() -> Nil {
  io.println("Hello from mysql_slowquerylog_duration!")
}
