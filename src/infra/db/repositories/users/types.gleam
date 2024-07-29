import gleam/option.{type Option}
import gleam/dynamic.{type Dynamic}

pub type User {
  User(
    id: Int,
    name: String,
    email: String,
    age: Int
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

pub type SUser {
    SUserPayload(
        status: String
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