import gleam/result
import gleeunit
import stats

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn summarize_odd_test() {
  assert stats.summarize([3, 1, 4, 1, 5])
    == Ok(stats.Summary(
      count: 5,
      sum: 14,
      min: 1,
      max: 5,
      mean: 2.8,
      median: 3.0,
    ))
}

pub fn summarize_even_test() {
  assert stats.summarize([1, 2, 3, 4])
    == Ok(stats.Summary(
      count: 4,
      sum: 10,
      min: 1,
      max: 4,
      mean: 2.5,
      median: 2.5,
    ))
}

pub fn summarize_single_test() {
  assert stats.summarize([7])
    == Ok(stats.Summary(
      count: 1,
      sum: 7,
      min: 7,
      max: 7,
      mean: 7.0,
      median: 7.0,
    ))
}

pub fn summarize_empty_test() {
  assert stats.summarize([]) == Error(Nil)
}

pub fn parse_numbers_ok_test() {
  assert stats.parse_numbers(["1", "2", "3"]) == Ok([1, 2, 3])
}

pub fn parse_numbers_error_test() {
  assert result.is_error(stats.parse_numbers(["1", "x", "3"]))
}
