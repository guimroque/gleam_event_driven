
import app/routes/router
import gleam/http/elli

import gleam/http/response.{type Response}
import gleam/http/request.{type Request}
import gleam/bytes_builder.{type BytesBuilder}
import gleam/erlang/process.{start}

import rmq.{
    rmq_queue,
    rmq_topic,
    rmq_queue_bind,
    read_message
}


// Define a HTTP service
pub fn my_service(_request: Request(t)) -> Response(BytesBuilder) {
 let body = bytes_builder.from_string("Hello, world!")

 response.new(200)
 |> response.prepend_header("made-with", "Gleam")
 |> response.set_body(body)
}


// Start it on port 3000 using the Elli web server
pub fn main() {
    
    let queue = rmq_queue("")
    rmq_queue_bind(queue, "users", "")
    rmq_topic("users")
    start(fn() -> anything {
        read_message(queue)
    }, True)

    let queue2 = rmq_queue("")
    rmq_queue_bind(queue2, "transactions", "")
    rmq_topic("transactions")

    start(fn() -> anything {
        read_message(queue2)
    }, True)

    elli.become(router.run, on_port: 3000)
}