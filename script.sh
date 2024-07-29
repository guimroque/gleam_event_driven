#!/bin/bash

echo "Compiling Elixir..."
cd ./rabbitmq_client
mix compile

echo "Copying Elixir..."
cp -r ./_build/dev/lib/* ../build/dev/erlang/

echo "Compiling and Running Gleam..."
gleam run