# test/rabbitmq_client_test.exs
defmodule RabbitMQClientTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @rabbitmq_url "amqp://guest:guest@localhost"
  @queue "test_queue"

  setup do
    {:ok, %{connection: conn, channel: chan}} = RabbitMQClient.start_link(@rabbitmq_url)
    {:ok, %{connection: conn, channel: chan}}
  end

  # Send a message to a queue
  # Wait for the message to be received (500ms)
  # Verify send message to a queue log
  # Try to get the message from the queue
  # Check if the message is the same
  test "sends a message", %{channel: chan} do
    message = "Hello, RabbitMQ!"

    output = capture_io(fn ->
      RabbitMQClient.send_message(message, @queue, @rabbitmq_url)
    end)

    assert output == "Sent message: #{message}\n"
    :timer.sleep(500)

    {:ok, payload, _meta} = AMQP.Basic.get(chan, @queue, no_ack: true)
    assert payload == message
  end


  # Publish a message to a topic
  # Wait for the message to be received (500ms)
  # Verify receive message from a topic log
  # Check if the message is the same as the one sent
  test "receives a message", %{channel: chan} do
    message = "Hello, RabbitMQ!"
    AMQP.Basic.publish(chan, "", @queue, message)

    output = capture_io(fn ->
      Task.start(fn ->
        RabbitMQClient.listen_topic(@queue, @rabbitmq_url)
      end)
      Process.sleep(500)
    end)

    assert output == "Received message: #{message}\n"
  end
end
