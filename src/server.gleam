import gleam/http/response.{type Response}
import gleam/http/request.{type Request}
import gleam/bytes_builder.{type BytesBuilder}
import gleam/io

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
    rmq_elixir()
    |> io.println

    let topic = "users"
    rmq_listen(topic)

  
    let message = "Hello, world!"
    let routing_key = "teste_queue"

    let queue_name = "teste_queue"
    rmq_queue(queue_name)
    rmq_send(message, queue_name)
}

@external(erlang, "Elixir.RabbitMQClient", "main")
fn rmq_elixir() -> String

@external(erlang, "Elixir.RabbitMQClient", "listen_topic")
fn rmq_listen(topic_name topic_name: String) -> String

@external(erlang, "Elixir.RabbitMQClient", "declare_queue")
fn rmq_queue(declare_queue declare_queue: String) -> String

@external(erlang, "Elixir.RabbitMQClient", "send_message")
fn rmq_send(message message: String, routing_key routing_key: String) -> String