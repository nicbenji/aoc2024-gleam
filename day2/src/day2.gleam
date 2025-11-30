import file_streams/file_stream.{type FileStream}
import file_streams/file_stream_error.{type FileStreamError}
import gleam/int
import gleam/list.{Continue, Stop}
import gleam/order
import gleam/result
import gleam/string

const filepath = "day2.txt"

const sint32_max = 2_147_483_648

pub fn main() -> Nil {
  let s = 0
  let assert Ok(stream) = file_stream.open_read(filepath)
  let s = count_safe_reports(s, stream)
  echo s as "Amount of safe reports"

  Nil
}

fn count_safe_reports(acc: Int, stream: FileStream) -> Int {
  case next_report(stream) {
    Error(file_stream_error.Eof) -> acc
    Ok(report) -> {
      case check_safety(report) {
        False -> count_safe_reports(acc, stream)
        True -> count_safe_reports(acc + 1, stream)
      }
    }
    _ -> -1
  }
}

fn check_safety(report: List(Int)) -> Bool {
  let start_order = case report {
    [a, b, ..] -> int.compare(a, b)
    _ -> order.Eq
  }
  let #(_, is_safe) =
    report
    |> list.window_by_2()
    |> list.fold_until(#(start_order, True), fn(acc, t) {
      let has_trend = case int.compare(t.0, t.1) == acc.0 {
        True -> Continue(#(acc.0, True))
        False -> Stop(#(acc.0, False))
      }

      let abs_val = int.absolute_value(t.0 - t.1)
      case abs_val >= 1 && abs_val <= 3 {
        True -> has_trend
        False -> Stop(#(acc.0, False))
      }
    })
  is_safe
}

fn next_report(stream: FileStream) -> Result(List(Int), FileStreamError) {
  use line <- result.try(file_stream.read_line(stream))
  let parts = string.split(line, " ")
  let report =
    parts
    |> list.map(fn(x) {
      x |> string.trim() |> int.parse() |> result.unwrap(-sint32_max)
    })
  Ok(report)
}
// vim: ts=2 sts=2 sw=2 et
