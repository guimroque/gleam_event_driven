import gleam/pgo.{type Connection, Config}
import gleam/option.{Some}

pub fn connect() -> Connection {
  Config(
    ..pgo.default_config(),// -> host, port, user, database
    password: Some("postgres"),
  )
  |> pgo.connect()
}

pub fn disconnect(db: Connection) -> Nil {
  pgo.disconnect(db)
}


pub fn default_conn_url() -> String {
  "postgres://postgres:postgres@localhost:5432/postgres"  
}
