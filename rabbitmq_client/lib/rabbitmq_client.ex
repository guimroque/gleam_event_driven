# lib/rabbitmq_client.ex
defmodule RabbitMQClient do
  use AMQP

  # Start a connection and open a channel
  # Params:
  #   - url_conn: String
  # This function will:
  #   - Open a connection
  #   - Open a channel
  def start_link(url_conn) do
    case Connection.open(url_conn) do
      {:ok, connection} ->
        case Channel.open(connection) do
          {:ok, channel} -> {:ok, %{connection: connection, channel: channel}}
          {:error, reason} -> {:error, reason}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  # Declare a queue (just to debbug or test)
  # Params:
  #   - channel: AMQP.Channel.t()
  #   - queue_name: String
  # This function will:
  #   - Declare a queue with the given name
  def declare_queue(channel, queue_name) do
    Queue.declare(channel, queue_name, durable: true)
  end

  # Send a message to a queue
  # Params:
  #   - message: String
  #   - topic: String
  #   - url_conn: String
  # This function will:
  #   - Start a connection
  #   - Publish a message to the queue
  def send_message(message, topic, url_conn) do
    case start_link(url_conn) do
      {:ok, %{channel: channel}} ->
        Basic.publish(channel, "", topic, message)
        IO.puts "Sent message: #{message}"

      {:error, reason} ->
        IO.puts "Failed to send message: #{reason}"
    end
  end

  # Listen to a topic
  # Params:
  #   - topic_name: String
  #   - url_conn: String
  # This function will:
  #   - Start a connection
  #   - Consume messages from the queue
  #   - Wait for messages
  def listen_topic(topic_name, url_conn) do
    case start_link(url_conn) do
      {:ok, %{channel: channel}} ->
        case Basic.consume(channel, topic_name, nil, no_ack: true) do
          {:ok, _consumer_tag} ->
            receive do
              {:basic_deliver, payload, _meta} ->
                IO.puts "Received message: #{payload}"
                listen_topic(topic_name, url_conn)
            end

          {:error, reason} ->
            IO.puts "Failed to consume messages: #{reason}"
        end

      {:error, reason} ->
        IO.puts "Failed to connect: #{reason}"
    end
  end
end
