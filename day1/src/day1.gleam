import file_streams/file_stream.{type FileStream}
import file_streams/file_stream_error
import gleam/io

pub fn main() -> Nil {
  let filepath = "day1.txt"

  let assert Ok(stream) = file_stream.open_read(filepath)
  let #(n, m) = read_file(stream)

  echo stream

  Nil
}

fn read_file(stream: FileStream) -> #(List(Int), List(Int)) {
  let n = []
  let m = []
  let line = file_stream.read_bytes(stream, 5)
  #(n, m)
}

fn read_line(line: String) -> String {
  case line {
    
  }
  line
}
