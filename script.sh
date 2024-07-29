#!/bin/bash

echo "Compiling Elixir..."
cd ./rabbitmq_client
mix compile

echo "Copying Elixir..."
cp -r ./_build/dev/lib/* ../build/dev/erlang/

echo "Starting services"
docker-compose up -d

echo "Prepare databse..."
docker cp src/db/init/create_tables.sql postgres:/create_tables.sql
docker exec -it postgres psql -U postgres -d postgres -f /create_tables.sql


echo "Compiling and Running Gleam..."
gleam run