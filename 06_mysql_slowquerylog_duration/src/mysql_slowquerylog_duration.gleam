import gleam/io
import gleam/time/duration.{type Duration}
import mysql_slowquerylog_duration/period.{type Period}

pub fn format_duration(duration: Duration) -> String {
  todo
}

pub fn summarize(lines: List(String)) -> Result(#(Period, Int, Int), String) {
  todo
}

pub fn main() -> Nil {
  io.println("Hello from mysql_slowquerylog_duration!")
}
