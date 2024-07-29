import db/repositories/users/types.{type SimpleUser, SimpleUserPayload}
import gleam/dynamic.{type Dynamic}
import gleam/json
import gleam/io


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
            io.println("-----------------[USER]-----------------")
            io.println(user.name)
            io.println(user.status)
            io.println(user.public_key)
            io.println(user.created_at)
            io.println("-----------------[USER]-----------------")
            // io.println(user)
            Ok(user)
        }
        Error(e) -> {
            //io.println("error")
            io.debug(e)
            Error("error")
        }
    }
}