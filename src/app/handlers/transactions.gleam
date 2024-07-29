import app/handlers/common.{
  identity_to_json,
  handle_json_response,
  handle_method_not_allowed
}

import gleam/io
import gleam/json.{object, array, int}
import gleam/http/request.{type Request}
import gleam/http.{Get, Post, Patch, Put}
import gleam/http/response.{type Response}
import gleam/bytes_builder.{type BytesBuilder}

pub fn get_transactions(request: Request(t)) -> Response(BytesBuilder) {
  case request.method {
    Get -> {
      io.debug("get_transactions")
      io.debug(request)
      // Simula retorno de todas as transações
      let json_object = object([
        #("transactions", array([], identity_to_json)),
        #("count", int(0))
      ])

      handle_json_response(json_object)
    }
    
    Post -> handle_method_not_allowed()
    Patch -> handle_method_not_allowed()
    Put -> handle_method_not_allowed()
    _ -> handle_method_not_allowed()
  }
}
