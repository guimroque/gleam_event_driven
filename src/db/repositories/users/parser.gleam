import db/repositories/users/types.{
    type DefaultUserEventRequestPayload, 
    type SimpleUser, 
    SimpleUserPayload,
    UserPayload,
    DefaultUserEventPayload,
    type User
}
import gleam/dynamic
import gleam/json
import gleam/io
import youid/uuid
import db/repositories/users/user_repository.{insert_user_repository}



pub fn get_simple_user(payload: String) -> Result(SimpleUser, String) {
    let simple_user_decode = dynamic.decode4(
        SimpleUserPayload,
        dynamic.field("name", of: dynamic.string),
        dynamic.field("public_key", of: dynamic.string),
        dynamic.field("status", of: dynamic.string),
        dynamic.field("created_at", of: dynamic.string),
    )

    case json.decode(payload, simple_user_decode) {
        Ok(user) -> {
            Ok(user)
        }
        Error(e) -> {
            io.debug(e)
            Error("error")
        }
    }
}

pub fn get_complete_user(payload: String) -> Result(User, String) {
    let simple_user_decode = dynamic.decode9(
        UserPayload,
        dynamic.field("id", of: dynamic.string),
        dynamic.field("name", of: dynamic.string),
        dynamic.field("email", of: dynamic.string),
        dynamic.field("public_key", of: dynamic.string),
        dynamic.field("status", of: dynamic.string),
        dynamic.field("balance", of: dynamic.float),
        dynamic.field("currency", of: dynamic.string),
        dynamic.field("created_at", of: dynamic.string),
        dynamic.optional_field("reason", of: dynamic.string),
    )

    case json.decode(payload, simple_user_decode) {
        Ok(user) -> {
            Ok(user)
        }
        Error(e) -> {
            io.debug(e)
            Error("error")
        }
    }
}

pub fn add_user(payload: String) -> Bool {
    let simple_user_decode = dynamic.decode9(
        UserPayload,
        dynamic.field("id", of: dynamic.string),
        dynamic.field("name", of: dynamic.string),
        dynamic.field("email", of: dynamic.string),
        dynamic.field("public_key", of: dynamic.string),
        dynamic.field("status", of: dynamic.string),
        dynamic.field("balance", of: dynamic.float),
        dynamic.field("currency", of: dynamic.string),
        dynamic.field("created_at", of: dynamic.string),
        dynamic.optional_field("reason", of: dynamic.string),
    )

    case json.decode(payload, simple_user_decode) {
        Ok(user) -> {
            insert_user_repository(user)
            True
        }
        Error(e) -> {
            io.debug(e)
            False
        }
    }
}



pub fn parse_user_request_payload(payload: String) -> Result(DefaultUserEventRequestPayload, String) {
    let user_decode = dynamic.decode7(
        DefaultUserEventPayload,
        dynamic.field("event", of: dynamic.string),
        dynamic.field("name", of: dynamic.string),
        dynamic.field("email", of: dynamic.string),
        dynamic.field("public_key", of: dynamic.string),
        dynamic.field("balance", of: dynamic.float),
        dynamic.field("currency", of: dynamic.string),
        dynamic.field("created_at", of: dynamic.string),
    )

  case json.decode(payload, user_decode) {
        Ok(user) -> Ok(user)
        Error(e) -> {
            io.debug(e)
            Error("error")
        }
    }
}

pub fn user_request_confirm(user: String) -> String {
    let user = parse_user_request_payload(user)
    case user {
        Ok(user) -> {
            let user_id = uuid.v4_string()
            let user_status = "review"
            let user_event_type = "User.Pending"

            json.object([
                #("event", json.string(user_event_type)), // set event
                #("id", json.string(user_id)),
                #("email", json.string(user.email)),
                #("status", json.string("review")),
                #("name", json.string(user.name)),
                #("balance", json.float(user.balance)),
                #("currency", json.string(user.currency)),
                #("public_key", json.string(user.public_key)),
                #("created_at", json.string(user.created_at)),
                // new fields
                #("id", json.string(user_id)),
                #("status", json.string(user_status)),
                // #("reason", json.null),
                //#("updated_at", json.string(user.created_at)),
            ])
            |> json.to_string
        }
        Error(e) -> {
            io.debug(e)
            "error"
        }
    }
}

