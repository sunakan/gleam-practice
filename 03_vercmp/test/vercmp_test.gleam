import gleam/order
import gleeunit
import vercmp

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn compare_lt_test() {
  assert vercmp.compare([1, 2], [1, 10]) == order.Lt
}

pub fn compare_gt_test() {
  assert vercmp.compare([1, 10], [1, 2]) == order.Gt
}

pub fn compare_eq_test() {
  assert vercmp.compare([1, 2, 3], [1, 2, 3]) == order.Eq
}

pub fn compare_trailing_zero_is_eq_test() {
  assert vercmp.compare([1, 2], [1, 2, 0]) == order.Eq
}

pub fn compare_shorter_is_lt_test() {
  assert vercmp.compare([1, 2], [1, 2, 1]) == order.Lt
}

pub fn compare_longer_is_gt_test() {
  assert vercmp.compare([1, 0, 0, 5], [1]) == order.Gt
}

pub fn compare_first_difference_wins_test() {
  assert vercmp.compare([2], [1, 9, 9, 9]) == order.Gt
}

pub fn parse_version_test() {
  assert vercmp.parse_version("1.2.3") == Ok([1, 2, 3])
}

pub fn parse_version_single_test() {
  assert vercmp.parse_version("1") == Ok([1])
}

pub fn parse_version_empty_test() {
  assert vercmp.parse_version("") == Error("不正なバージョン: ")
}

pub fn parse_version_empty_part_test() {
  assert vercmp.parse_version("1..2") == Error("不正なバージョン: 1..2")
}

pub fn parse_version_leading_dot_test() {
  assert vercmp.parse_version(".1") == Error("不正なバージョン: .1")
}

pub fn parse_version_trailing_dot_test() {
  assert vercmp.parse_version("1.") == Error("不正なバージョン: 1.")
}

pub fn parse_version_not_number_test() {
  assert vercmp.parse_version("1.x") == Error("不正なバージョン: 1.x")
}

pub fn parse_version_negative_test() {
  assert vercmp.parse_version("1.-1") == Error("不正なバージョン: 1.-1")
}
