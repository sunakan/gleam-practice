import gleam/order
import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}

/// 開始時刻と終了時刻を持つ区間
/// start <= end をnewで保証する
pub opaque type Period {
  Period(start: Timestamp, end: Timestamp)
}

pub fn new(start: Timestamp, end: Timestamp) -> Result(Period, String) {
  case timestamp.compare(start, end) {
    order.Lt | order.Eq -> Ok(Period(start: start, end: end))
    order.Gt -> Error("start <= endである必要があります")
  }
}

pub fn start(period: Period) -> Timestamp {
  period.start
}

pub fn end(period: Period) -> Timestamp {
  period.end
}

pub fn duration(period: Period) -> Duration {
  timestamp.difference(period.start, period.end)
}
