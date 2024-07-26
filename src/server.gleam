import gleam/http/elli
import gleam/http/response.{type Response}
import gleam/http/request.{type Request}
import gleam/bytes_builder.{type BytesBuilder}
import gleam/erlang

// Define a HTTP service
//
pub fn my_service(_request: Request(t)) -> Response(BytesBuilder) {
 let body = bytes_builder.from_string("Hello, world!")

 response.new(200)
 |> response.prepend_header("made-with", "Gleam")
 |> response.set_body(body)
}

// Start it on port 3000 using the Elli web server
//
pub fn main() {
 elli.become(my_service, on_port: 3000)
}

// connecta
// abre um canal
// declara queue