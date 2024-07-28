import app/handlers/common.{
  identity_to_json,
  handle_json_response,
  handle_method_not_allowed
}

import gleam/io
import gleam/http.{Get, Post, Patch, Put}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json.{object, string,array, int}
import gleam/bytes_builder.{type BytesBuilder}

pub fn get_users(request: Request(t)) -> Response(BytesBuilder) {
  case request.method {
    Get -> {
      // Criação do objeto JSON para a resposta
      io.debug("get_users")
      io.debug(request)
      let json_object = object([
        #("users", array([], identity_to_json)), // Simula lista de usuários
        #("count", int(0)) // Simula contagem de usuários
      ])

      handle_json_response(json_object)
    }
    Post -> handle_method_not_allowed()
    Patch -> handle_method_not_allowed()
    Put -> handle_method_not_allowed()
    _ -> handle_method_not_allowed()
  }
}

pub fn get_user_by_id(request: Request(t), id: String) -> Response(BytesBuilder) {
  case request.method {
    Get -> {
      io.debug("get_user_by_id")
      io.debug(id)
      // Simula retorno de um usuário por ID
      let json_object = object([
        #("id", string(id)),
        #("name", string("User Name"))
      ])

      handle_json_response(json_object)
    }

    Post -> handle_method_not_allowed()
    Patch -> handle_method_not_allowed()
    Put -> handle_method_not_allowed()
    _ -> handle_method_not_allowed()
  }
}

pub fn get_user_transactions(request: Request(t), id: String) -> Response(BytesBuilder) {
  case request.method {
    Get -> {
      io.debug("get_user_transactions")
      io.debug(id)
      // Simula retorno de transações do usuário
      let json_object = object([
        #("user_id", string(id)),
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

pub fn get_user_transaction_by_user_id_and_transaction_id(request: Request(t), id: String, tx: String) -> Response(BytesBuilder) {
  case request.method {
    Get -> {
      io.debug("get_user_transaction_by_user_id_and_transaction_id")
      io.debug(id)
      io.debug(tx)
      // Simula retorno de uma transação do usuário por ID
      let json_object = object([
        #("user_id", string(id)),
        #("id", string(tx)),
        #("sender", string("Sender Name"))
      ])

      handle_json_response(json_object)
    }

    Post -> handle_method_not_allowed()
    Patch -> handle_method_not_allowed()
    Put -> handle_method_not_allowed()
    _ -> handle_method_not_allowed()
  }
}

pub fn get_user_transaction_by_user_id_and_transaction_status(request: Request(t), id: String, status: String) -> Response(BytesBuilder) {
  case request.method {
    Get -> {
      io.debug("get_user_transaction_by_user_id_and_transaction_status")
      io.debug(id)
      io.debug(status)
      // Simula retorno de transações do usuário com status
      let json_object = object([
        #("user_id", string(id)),
        #("transactions", array([], identity_to_json)),
        #("status", string(status))
      ])

      handle_json_response(json_object)
    }
    
    Post -> handle_method_not_allowed()
    Patch -> handle_method_not_allowed()
    Put -> handle_method_not_allowed()
    _ -> handle_method_not_allowed()
  }
}