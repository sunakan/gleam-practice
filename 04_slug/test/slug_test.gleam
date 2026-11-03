import gleeunit
import slug

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn slugify_basic_test() {
  assert slug.slugify("Hello, World!") == "hello-world"
}

pub fn slugify_multiple_spaces_test() {
  assert slug.slugify("Gleam is   fun") == "gleam-is-fun"
}

pub fn slugify_digits_test() {
  assert slug.slugify("Hello, World! 2026") == "hello-world-2026"
}

pub fn slugify_uppercase_and_digits_test() {
  assert slug.slugify("ABC123") == "abc123"
}

pub fn slugify_trims_separators_test() {
  assert slug.slugify("--a--b--") == "a-b"
}

pub fn slugify_trims_spaces_test() {
  assert slug.slugify("  trim me  ") == "trim-me"
}

pub fn slugify_non_ascii_is_separator_test() {
  assert slug.slugify("a日本語b") == "a-b"
}

pub fn slugify_only_non_ascii_test() {
  assert slug.slugify("日本語") == ""
}

pub fn slugify_empty_test() {
  assert slug.slugify("") == ""
}
