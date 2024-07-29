import gleam/io
import infra/db/config.{connect}
import gleam/dynamic.{type Dynamic, dynamic}
import gleam/pgo.{
  type QueryError,
  type Returned
}

pub fn get_all_users_repository() -> Result(Returned(Dynamic), QueryError) {
  // Conectar ao banco de dados
  let db = connect()
  io.debug(db)

  // Definir a consulta SQL para buscar todos os usuários
  let sql = "SELECT * FROM users"

  // Executar a consulta
  let result = pgo.execute(sql, db, [], dynamic.dynamic)

  // Manipular o resultado
   case result {
    Ok(returned) -> {
      Ok(returned)
    }
    Error(err) -> Error(err)
  }
}