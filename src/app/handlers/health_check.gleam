import app/handlers/common.{
  handle_json_response,
  handle_method_not_allowed
}

import gleam/json.{object, string}
import gleam/http/request.{type Request}
import gleam/http.{Get, Post, Patch, Put}
import gleam/http/response.{type Response}
import gleam/bytes_builder.{type BytesBuilder}


pub fn ping(request: Request(t)) -> Response(BytesBuilder) {
  case request.method {
    Get -> {
      let json_object = object([
        #("message", string("ping"))
      ])
      
      handle_json_response(json_object)
    }

    Post -> handle_method_not_allowed()
    Patch -> handle_method_not_allowed()
    Put -> handle_method_not_allowed()
    _ -> handle_method_not_allowed()
  }
}
