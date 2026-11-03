import gleam/int
import gleam/list
import gleam/string
import gleeunit
import ipv4_parse_with_pbt
import ipv4_parse_with_pbt/ipv4.{
  EmptyOctet, LeadingZero, NotANumber, OutOfRange, WrongOctetCount,
}
import qcheck

pub fn main() -> Nil {
  gleeunit.main()
}

//
// ヘルパー
//
// octet(オクテット(.))
fn join(octets: List(Int)) -> String {
  octets |> list.map(int.to_string) |> string.join(".")
}

// 有効な1要素 (0~255)
fn octet() -> qcheck.Generator(Int) {
  qcheck.bounded_int(0, 255)
}

//
// 単体テスト: エラー
//
pub fn wrong_octet_count_test() {
  assert ipv4.parse("") == Error(WrongOctetCount(1))
  assert ipv4.parse("1.2.3") == Error(WrongOctetCount(3))
  assert ipv4.parse("1.2.3.4.5") == Error(WrongOctetCount(5))
}

pub fn empty_octet_test() {
  assert ipv4.parse("1..3.4") == Error(EmptyOctet)
  assert ipv4.parse(".2.3.4") == Error(EmptyOctet)
  assert ipv4.parse("1.2.3.") == Error(EmptyOctet)
}

pub fn not_a_number_test() {
  assert ipv4.parse("a.2.3.4") == Error(NotANumber("a"))
  assert ipv4.parse("+1.2.3.4") == Error(NotANumber("+1"))
  assert ipv4.parse("1.-1.3.4") == Error(NotANumber("-1"))
  assert ipv4.parse("1.2.3.4x") == Error(NotANumber("4x"))
}

pub fn leading_zero_test() {
  assert ipv4.parse("01.2.3.4") == Error(LeadingZero("01"))
  assert ipv4.parse("1.2.3.00") == Error(LeadingZero("00"))
}

pub fn out_of_range_test() {
  assert ipv4.parse("1.2.3.256") == Error(OutOfRange(256))
  assert ipv4.parse("999.2.3.4") == Error(OutOfRange(999))
}

// 判定順: 要素数 → 左から最初に当てはまる要素のエラー
pub fn error_priority_test() {
  assert ipv4.parse("a.b.c") == Error(WrongOctetCount(3))
  assert ipv4.parse("a.01.256.4") == Error(NotANumber("a"))
  assert ipv4.parse("1.01.256.4") == Error(LeadingZero("01"))
  assert ipv4.parse("1.256.01.4") == Error(OutOfRange(256))
}

//
// 単体テスト: 有効
//
pub fn zero_is_valid_test() {
  assert ipv4.parse("0.0.0.0") |> result_octets == Ok(#(0, 0, 0, 0))
  assert ipv4.parse("255.255.255.255") |> result_octets
    == Ok(#(255, 255, 255, 255))
}

fn result_octets(
  r: Result(ipv4.Ipv4, ipv4.Ipv4Error),
) -> Result(#(Int, Int, Int, Int), ipv4.Ipv4Error) {
  case r {
    Ok(ip) -> Ok(ipv4.octets(ip))
    Error(e) -> Error(e)
  }
}

pub fn from_octets_test() {
  assert ipv4.from_octets(256, 0, 0, 1) == Error(OutOfRange(256))
  assert ipv4.from_octets(1, 2, -1, 4) == Error(OutOfRange(-1))
  assert ipv4.from_octets(192, 168, 0, 1) |> result_octets
    == Ok(#(192, 168, 0, 1))
}

pub fn to_string_test() {
  assert ipv4.from_octets(192, 168, 0, 1) |> result_to_string
    == Ok("192.168.0.1")
}

fn result_to_string(
  r: Result(ipv4.Ipv4, ipv4.Ipv4Error),
) -> Result(String, ipv4.Ipv4Error) {
  case r {
    Ok(ip) -> Ok(ipv4.to_string(ip))
    Error(e) -> Error(e)
  }
}

//
// 単体テスト: エラー文
//
pub fn error_to_string_test() {
  assert ipv4.error_to_string(WrongOctetCount(3)) == "要素の数が4ではありません(3)"
  assert ipv4.error_to_string(EmptyOctet) == "空の要素があります"
  assert ipv4.error_to_string(NotANumber("x")) == "数字ではありません: x"
  assert ipv4.error_to_string(LeadingZero("01")) == "先頭に0があります: 01"
  assert ipv4.error_to_string(OutOfRange(256)) == "範囲外です: 256"
}

//
// 単体テスト: CLI の1行表示
//
pub fn format_line_test() {
  assert ipv4_parse_with_pbt.format_line("192.168.0.1") == "192.168.0.1 ok"
  assert ipv4_parse_with_pbt.format_line("1.2.3.256")
    == "1.2.3.256 error: 範囲外です: 256"
  assert ipv4_parse_with_pbt.format_line("a.b.c.d")
    == "a.b.c.d error: 数字ではありません: a"
}

//
// PBT
//
// ①往復: parse → octets / to_string で元に戻せる
// ②1要素だけ 256~なら、位置によらず Out Of Range
// ③要素数が4以外なら、必ずWrongOctetCount

// ①往復: parse → octets / to_string で元に戻せる
pub fn roundtrip_property_test() {
  qcheck.given(qcheck.tuple4(octet(), octet(), octet(), octet()), fn(t) {
    let #(a, b, c, d) = t
    let s = join([a, b, c, d])
    let assert Ok(ip) = ipv4.parse(s)
    assert ipv4.octets(ip) == #(a, b, c, d)
    assert ipv4.to_string(ip) == s
  })
}

// ②1要素だけ 256~なら、位置によらず Out Of Range
pub fn out_of_range_property_test() {
  let gen =
    qcheck.tuple3(
      qcheck.bounded_int(0, 3),
      // pos: 0~3
      qcheck.bounded_int(256, 999),
      // bad: 256~999
      qcheck.tuple4(octet(), octet(), octet(), octet()),
    )
  // s: 1要素だけbadなipを作成
  qcheck.given(gen, fn(t) {
    let #(pos, bad, #(a, b, c, d)) = t
    let s =
      [a, b, c, d]
      |> list.index_map(fn(v, i) {
        case i == pos {
          True -> bad
          False -> v
        }
      })
      |> join
    assert ipv4.parse(s) == Error(OutOfRange(bad))
  })
}

// ③要素数が4以外なら、必ずWrongOctetCount
pub fn wrong_count_property_test() {
  // 4以外を表現
  let count_gen =
    qcheck.bounded_int(1, 19)
    |> qcheck.map(fn(n) {
      case n >= 4 {
        True -> n + 1
        False -> n
      }
    })
  // 長さnのoctetsを用意
  let gen = {
    use n <- qcheck.bind(count_gen)
    qcheck.fixed_length_list_from(octet(), n)
  }
  qcheck.given(gen, fn(octets) {
    assert ipv4.parse(join(octets))
      == Error(WrongOctetCount(list.length(octets)))
  })
}
