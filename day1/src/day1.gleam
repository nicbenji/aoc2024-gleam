import file_streams/file_stream.{type FileStream}
import file_streams/file_stream_error.{type FileStreamError}
import gleam/result

pub fn main() -> Nil {
  let filepath = "day1.txt"

  let #(n, m) = read_file(filepath)

  Nil
}

fn read_file(filepath: String) -> #(List(Int), List(Int)) {
  let n = []
  let m = []
  let assert Ok(stream) = file_stream.open_read(filepath)
  let line = file_stream.read_line(stream)

  #(n, m)
}
