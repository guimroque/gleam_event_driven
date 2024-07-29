defmodule RabbitMQClient do
  use AMQP

  @rabbitmq_url "amqp://guest:guest@localhost"

  # Start a connection and open a channel
  def start_link() do
    case Connection.open(@rabbitmq_url) do
      {:ok, connection} ->
        case Channel.open(connection) do
          {:ok, channel} -> {:ok, %{connection: connection, channel: channel}}
          {:error, reason} -> {:error, reason}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  # Declare a queue
  def declare_queue(queue_name) do
    case start_link() do
      {:ok, %{connection: connection, channel: channel}} ->
        case AMQP.Queue.declare(channel, queue_name, durable: false) do
          {:ok, %{queue: queue_name}} ->
            queue_name
          {:error, reason} ->
            IO.puts "Failed to declare queue: #{reason}"
            AMQP.Connection.close(connection)
        end

      {:error, reason} ->
        IO.puts "Failed to connect to RabbitMQ: #{reason}"
    end
  end

  def declare_topic(topic_name) do
    case start_link() do
      {:ok, %{connection: connection, channel: channel}} ->
        case AMQP.Exchange.declare(channel, topic_name, :fanout) do
          :ok ->
            {:ok }

          {:error, reason} ->
            IO.puts "Failed to declare topic: #{reason}"
            AMQP.Connection.close(connection)
        end

      {:error, reason} ->
        IO.puts "Failed to connect to RabbitMQ: #{reason}"
    end
  end


  # Consumer 1 ->
  # Queue1 <-

  # Consumer 2 ->
  # Queue2 <-

  # Exchange -> Topic -> Queue1, Queue2
  # Publish -> Topic -> Queue1, Queue2

  def queue_bind(queue_name, topic_name, routing_key) do
    case start_link() do
      {:ok, %{connection: connection, channel: channel}} ->
        AMQP.Queue.bind(channel, queue_name, topic_name, [])

      {:error, reason} ->
        IO.puts "Failed to connect to RabbitMQ: #{reason}"
    end
  end

  # Send a message to a queue
  def send_message(message, routing_key) do
    # IO.puts "Sending message: #{message}"
    case start_link() do
      {:ok, %{connection: connection, channel: channel}} ->
        # Publish the message
        case AMQP.Basic.publish(channel, routing_key, "", message, []) do
          :ok ->
            IO.puts "Message sent successfully"

          {:error, reason} ->
            IO.puts "Failed to send message: #{reason}"
        end

      {:error, reason} ->
        IO.puts "Failed to connect to RabbitMQ: #{reason}"
    end
  end

  # Listen to a topic and return the received message as a string
  def listen_topic(topic_name) do
    case start_link() do
      {:ok, %{channel: channel}} ->
        case Basic.consume(channel, topic_name, nil, no_ack: false) do
          {:ok, _consumer_tag} ->
            receive do
              {:basic_deliver, payload, _meta} ->
                payload
            after
              10000 -> # Timeout to stop waiting after 10 seconds of inactivity
                IO.puts "Listening stopped due to inactivity."
                "No message received"
            end

          {:error, reason} ->
            IO.puts "Failed to consume messages: #{reason}"
            "Failed to consume messages"
        end

      {:error, reason} ->
        IO.puts "Failed to connect: #{reason}"
        "Failed to connect"
    end
  end






end
