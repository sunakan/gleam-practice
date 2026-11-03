import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}

/// 開始時刻と終了時刻を持つ区間
/// start <= end をnewで保証する
pub opaque type Period {
  Period(start: Timestamp, end: Timestamp)
}

pub fn new(start: Timestamp, end: Timestamp) -> Result(Period, String) {
  todo
}

pub fn start(period: Period) -> Timestamp {
  todo
}

pub fn end(period: Period) -> Timestamp {
  todo
}

pub fn duration(period: Period) -> Duration {
  todo
}
