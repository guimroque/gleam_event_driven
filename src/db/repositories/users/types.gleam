import gleam/option.{type Option}
import gleam/dynamic.{type Dynamic}

pub type User {
  User(
    id: String,
    name: String,
    email: String,
    public_key: String,
    status: String, // todo: move to enum
    balance: Float,
    currency: String, // todo: move to enum
    created_at: String,
    updated_at: String,
  )
}

// Definindo o tipo para o resultado da consulta
pub type QueryResult {
  Record(
    count: Int,
    rows: List(Dynamic)
  )
}

pub type DefaultUserEventRequestPayload {
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

pub type SimpleUser {
    SimpleUserPayload(
        name: String,
        public_key: String,
        status: String,
        created_at: String,
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