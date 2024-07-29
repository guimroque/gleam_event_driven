
import app/routes/router
import gleam/http/elli

import gleam/io
import gleam/http/response.{type Response}
import gleam/http/request.{type Request}
import gleam/bytes_builder.{type BytesBuilder}
import gleam/erlang/atom.{type Atom}
import gleam/erlang/process.{start}
import gleam/json.{decode}
import gleam/string
import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option, Some}
import wisp

// Define a HTTP service
//
pub fn my_service(_request: Request(t)) -> Response(BytesBuilder) {
 let body = bytes_builder.from_string("Hello, world!")

 response.new(200)
 |> response.prepend_header("made-with", "Gleam")
 |> response.set_body(body)
}


// Start it on port 3000 using the Elli web server
pub fn main() {
 elli.become(router.run, on_port: 3000)
    let queue = rmq_queue("")
    rmq_queue_bind(queue, "users", "")
    rmq_topic("users")
    // let event = json.object([
    //     #("event", json.string("User.Pending")),
    //     #("email", json.string("asd@gmail.com")),
    //     #("status", json.string("review")),
    //     #("name", json.string("grub")),
    //     #("balance", json.float(0.0)),
    //     #("currency", json.string("ic")),
    //     #("public_key", json.string("asd")),
    //     #("created_at", json.string("2024-07-29T17:33:32.842340042Z")),
    //     #("updated_at", json.string("2024-07-29T17:33:32.842340042Z")),
    // ])
    // |> json.to_string
    // rmq_send(event, "users")
    start(fn() -> anything {
        print_message(queue)
    }, True)

    let queue2 = rmq_queue("")
    rmq_queue_bind(queue2, "transactions", "")
    rmq_topic("transactions")

    start(fn() -> anything {
        print_message(queue2)
    }, True)


    process.sleep_forever()
}

pub type DefaultUserEventPayload {
  DefaultUserEventPayload(
    event: String,
    name: String,
    email: String,
    public_key: String,
    balance: Float,
    currency: String,
    created_at: String,
  )
}
type SUser {
    SUserPayload(
        status: String,
        // reason: Option(String),
    )
}

pub type PendingUserEventPayload {
    PendingUserEventPayload(
        event: String,
        name: String,
        email: String,
        public_key: String,
        balance: String,
        currency: String,
        created_at: String,
        // NEW FIELDS
        id: String,
        status: String,
        reason: Option(String),
        updated_at: String,
    )
}

pub type UserEventPayload {
  UserEventPayload(
    event: String,
    name: String,
    balance: String,
    currency: String,
    public_key: String,
    email: String,
    // status: Option(String),
    created_at: String,
    // updated_at: Option(String),
  )
}

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


pub fn parse_user_request_payload(payload: String) -> DefaultUserEventPayload {
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

// pub fn validate(user: UserEventPayload) -> Bool {
//     case user.event {
//         "User.Pending" -> user_pending(user)
//         "User.Created" -> True
//         "User.Request" -> user_request(user)
//         _ -> False
//     }
//     case user.status {
//         Some("review") -> True
//         _ -> False
//     }
// }

pub fn print_message(queue: String) {
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

    print_message(queue)
}

@external(erlang, "Elixir.RabbitMQClient", "listen_topic")
fn rmq_listen(topic_name topic_name: String) -> String

@external(erlang, "Elixir.RabbitMQClient", "declare_queue")
fn rmq_queue(declare_queue declare_queue: String) -> String

@external(erlang, "Elixir.RabbitMQClient", "declare_topic")
fn rmq_topic(declare_topic declare_topic: String) -> String

@external(erlang, "Elixir.RabbitMQClient", "queue_bind")
fn rmq_queue_bind(
    queue_name queue_name: String, 
    topic_name topic_name: String, 
    routing_key routing_key: String
) -> Atom

@external(erlang, "Elixir.RabbitMQClient", "send_message")
fn rmq_send(message message: String, routing_key routing_key: String) -> String

// @external(erlang, "Elixir.TimeProvider", "current_time")
// fn current_time() -> String