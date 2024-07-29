import gleam/pgo.{type Connection, Config}
import gleam/option.{Some}

pub fn connect() -> Connection {
  Config(
    ..pgo.default_config(),
    database: "gleam_event_driven",
    password: Some("postgres"),
    pool_size: 1,
  )
  |> pgo.connect
}

pub fn disconnect(db: Connection) -> Nil {
  pgo.disconnect(db)
}
