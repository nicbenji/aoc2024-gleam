import file_streams/file_stream.{type FileStream}
import file_streams/file_stream_error.{type FileStreamError}
import gleam/int
import gleam/list.{Continue, Stop}
import gleam/order
import gleam/result
import gleam/string

const filepath = "day1.txt"

pub fn main() -> Nil {
  let assert Ok(stream) = file_stream.open_read(filepath)

  let acc = #([], [])
  let #(n, m) = get_sorted_location_id_lists(stream, acc)
  let res = sum_of_diffs(n, m)
  echo res as "Result"

  let simi = similarity_score(n, m)
  echo simi as "Similarity Score"

  Nil
}

fn similarity_score(n: List(Int), m: List(Int)) -> Int {
  use score, num <- list.fold(n, 0)
  let amount =
    m
    |> list.fold_until(0, fn(acc, x) {
      case int.compare(num, x) {
        order.Lt -> Stop(acc)
        order.Eq -> Continue(acc + 1)
        order.Gt -> Continue(acc)
      }
    })

  score + { num * amount }
}

fn sum_of_diffs(n: List(Int), m: List(Int)) -> Int {
  list.zip(n, m)
  |> list.map(fn(pair) { int.absolute_value(pair.1 - pair.0) })
  |> list.reduce(fn(acc, curr) { acc + curr })
  |> result.unwrap(-1)
}

fn get_sorted_location_id_lists(
  stream: FileStream,
  acc: #(List(Int), List(Int)),
) -> #(List(Int), List(Int)) {
  case next_location_id_pair(stream) {
    Error(file_stream_error.Eof) -> {
      let by = int.compare
      let n = list.sort(acc.0, by:)
      let m = list.sort(acc.1, by:)
      #(n, m)
    }
    Ok(pair) -> {
      let new_acc = #([pair.0, ..acc.0], [pair.1, ..acc.1])
      get_sorted_location_id_lists(stream, new_acc)
    }
    _ -> #([], [])
  }
}

fn next_location_id_pair(
  stream: FileStream,
) -> Result(#(Int, Int), FileStreamError) {
  use line <- result.try(file_stream.read_line(stream))
  let assert Ok(parts) = string.split_once(line, " ")
  let assert Ok(n) = int.parse(parts.0)
  let assert Ok(m) = int.parse(string.trim(parts.1))
  Ok(#(n, m))
}
// vim: ts=2 sts=2 sw=2 et
