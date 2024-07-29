import gleam/json.{type Json, object, string, to_string}
import gleam/bytes_builder.{type BytesBuilder, from_string}
import gleam/http/response.{type Response, new, set_body, prepend_header}


pub fn handle_not_found() -> Response(BytesBuilder) {
  let json_object = object([
    #("message", string("404 Not Found"))
  ])

  let json_string = to_string(json_object)  
  let body = from_string(json_string)

  new(404)
  |> set_body(body)
  |> prepend_header("Content-Type", "application/json")
}

pub fn handle_method_not_allowed() -> Response(BytesBuilder) {
  let json_object = object([
    #("message", string("Method not allowed"))
  ])

  let json_string = to_string(json_object)  
  let body = from_string(json_string)

  new(405)
  |> set_body(body)
  |> prepend_header("Content-Type", "application/json")
}

pub fn handle_json_response(json_object: Json) -> Response(BytesBuilder) {
  let json_body = to_string(json_object)
  let body = from_string(json_body)

  new(200)
  |> prepend_header("Content-Type", "application/json")
  |> prepend_header("made-with", "Gleam")
  |> set_body(body)
}

pub fn handle_json_error(error: String) -> Response(BytesBuilder) {
  let json_object = object([
    #("message", string("Internal server error"))
  ])

  let json_string = to_string(json_object)  
  let body = from_string(json_string)

  new(500)
  |> set_body(body)
  |> prepend_header("Content-Type", "application/json")
}
// Função de conversão identidade para JSON
pub fn identity_to_json(x) -> Json {x}