import gleam/io
import gleam/json
import gleam/string
import gleam/dynamic

import wisp

import infra/db/repositories/users/types.{
    type DefaultUserEventRequestPayload, 
    DefaultUserEventPayload,
    SUserPayload
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

pub fn user_pending(user: String) -> Bool {
    io.println("User.Pending")
    True
}

// get user from payload
// create user_id
// set status to review
// set updated_at to created_at
// set event to User.Pending
// send user to rmq
pub fn user_request_confirm(user: String) -> Bool {
    let user = parse_user_request_payload(user)
    let user_id = wisp.random_string(20)
    let user_status = "review"
    let user_updated_at = user.created_at // todo: fix this
    let user_event_type = "User.Pending"

    let event = json.object([
        #("event", json.string(user_event_type)), // set event
        #("id", json.string(user_id)),
        #("email", json.string(user.email)),
        #("status", json.string("review")),
        #("name", json.string(user.name)),
        #("balance", json.float(user.balance)),
        #("currency", json.string(user.currency)),
        #("public_key", json.string(user.public_key)),
        #("created_at", json.string(user.created_at)),
        // new fields
        #("id", json.string(user_id)),
        #("status", json.string(user_status)),
        // #("reason", json.null),
        #("updated_at", json.string(user_updated_at)),
        
    ])
    |> json.to_string
    rmq_send(event, "users")

    True
}


pub fn parse_user_request_payload(payload: String) -> DefaultUserEventRequestPayload {
    let user_decode = dynamic.decode7(
        DefaultUserEventPayload,
        dynamic.field("event", of: dynamic.string),
        dynamic.field("name", of: dynamic.string),
        dynamic.field("email", of: dynamic.string),
        dynamic.field("public_key", of: dynamic.string),
        dynamic.field("balance", of: dynamic.float),
        dynamic.field("currency", of: dynamic.string),
        dynamic.field("created_at", of: dynamic.string),
    )

    case json.decode(payload, user_decode) {
        Ok(user) -> user
        Error(e) -> {
            io.debug(e)
            DefaultUserEventPayload("error", "error", "error", "error", 0.0, "error", "error")
        }
    }
}

pub fn parse_user_pending_payload(payload: String) -> Bool {
    // io.print(payload)
    let user_decode = dynamic.decode1(
        SUserPayload,
        dynamic.field("status", of: dynamic.string),
        //dynamic.field("reason", of: dynamic.optional(dynamic.string)),
    )

    case json.decode(payload, user_decode) {
        Ok(user) -> {
            io.println(user.status)
            // io.println(user)
            True
        }
        Error(e) -> {
            //io.println("error")
            io.debug(e)
            False
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
    // let _payload = string.replace("publicKey", "public_key", payload)
    
    case string.contains(payload, "User.Pending") {
        True -> {
            io.println("User.Pending")
            parse_user_pending_payload(payload)
            True
        }
        False -> False
    }
    case string.contains(payload, "User.Created"){
        True -> {
            io.println("User.Created")
            True
        }
        False -> False
    }
    case string.contains(payload, "User.Request"){
        True -> {
            io.println("User.Request")
            user_request_confirm(payload)
        }
        False -> False
    }

    read_message(queue)
}