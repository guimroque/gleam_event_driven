import gleam/io
import gleam/string


import db/repositories/users/parser.{
    get_simple_user,
    add_user, 
    user_request_confirm
}

import gleam/erlang/atom.{type Atom}

@external(erlang, "Elixir.RabbitMQClient", "listen_topic")
pub fn rmq_listen(topic_name topic_name: String) -> String

@external(erlang, "Elixir.RabbitMQClient", "declare_queue")
pub fn rmq_queue(declare_queue declare_queue: String) -> String

@external(erlang, "Elixir.RabbitMQClient", "declare_topic")
pub fn rmq_topic(declare_topic declare_topic: String) -> String

@external(erlang, "Elixir.RabbitMQClient", "send_message")
pub fn rmq_send(message message: String, routing_key routing_key: String) -> String

@external(erlang, "Elixir.RabbitMQClient", "queue_bind")
pub fn rmq_queue_bind(
    queue_name queue_name: String, 
    topic_name topic_name: String, 
    routing_key routing_key: String
) -> Atom

pub fn user_pending(payload: String) -> Bool {
    case get_simple_user(payload) {
        Ok(user) -> case user.status {
            "review" -> {
                True
            }
            "success" -> {
                add_user(payload)
                True
            }
            "failed" -> {
                add_user(payload)
                True
            }
            _ -> False
            
        }
        Error(e) -> {
            io.debug(e)
            False
        }
    }

}

pub fn user_request(payload: String) -> Bool {
    let message = user_request_confirm(payload) 
    case message {
        "error" -> {
            io.debug(message)
            False
        }
        _ -> {
            io.debug(message)
            rmq_send(message, "users")
            True
        }
    }

}

// read message from queue
// check if message contains User.Pending, User.Created or User.Request
// if User.Pending: 
//      verify user status:
//          if status is pending, send to user_pending
//          if status is approved, send to user_approved and create user on DB
//          if status is rejected, send to user_rejected and create user on DB with status rejected and reason
// if User.Created:
//      just ignore
// if User.Request:
//      verify payload and send to user_request_confirm
pub fn read_message(queue: String) {
    let payload = rmq_listen(queue)
    case string.contains(payload, "User.Pending") {
        True -> {
            user_pending(payload)
            True
        }
        False -> False
    }
    case string.contains(payload, "User.Created"){
        True -> {
            True
        }
        False -> False
    }
    case string.contains(payload, "User.Request"){
        True -> {
            user_request(payload)
        }
        False -> False
    }

    read_message(queue)
}