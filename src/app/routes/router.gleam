import app/handlers/users.{
  get_users,
  get_user_by_id,
  get_user_transactions,
  get_user_transaction_by_user_id_and_transaction_id,
  get_user_transaction_by_user_id_and_transaction_status
}
import app/handlers/health_check.{ping}
import app/handlers/transactions.{get_transactions}
import app/handlers/common.{handle_not_found}


import gleam/http/request.{type Request, path_segments}
import gleam/http/response.{type Response}
import gleam/bytes_builder.{type BytesBuilder}

pub fn run(request: Request(t)) -> Response(BytesBuilder) {
  let segments = path_segments(request)

  case segments {
    [] -> ping(request)
    ["users"] -> get_users(request)
    ["users", id] -> get_user_by_id(request, id)
    ["users", id, "transactions"] -> get_user_transactions(request, id)
    ["users", id, "transactions", tx] -> get_user_transaction_by_user_id_and_transaction_id(request, id, tx)
    ["users", id, "transactions", "status", status] -> get_user_transaction_by_user_id_and_transaction_status( request, id, status)
    ["transactions"] -> get_transactions(request)
    _ -> handle_not_found()
  }
}




