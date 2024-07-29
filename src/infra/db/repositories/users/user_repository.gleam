import infra/db/config.{connect}
import gleam/option.{Some}
import gleam/io
import gleam/result.{try, map_error}
import gleam/dynamic.{type Dynamic, dynamic, field,tuple2}
import gleam/pgo.{
  execute,
  type QueryError,
  type Returned,
  type Connection,
}

import gleam/json.{type Json, object, array, int}
import gleam/list.{concat}

pub fn get_all_users_repository() -> Result(Returned(Dynamic), QueryError) {
  // Conectar ao banco de dados
  let db = connect()
  io.debug(db)

  // Definir a consulta SQL para buscar todos os usuários
  let sql = "SELECT * FROM users"

  // Executar a consulta
  let result = pgo.execute(sql, db, [], dynamic.dynamic)

  // Log do resultado para fins de depuração
  io.debug("result")
  io.debug(result)
  io.debug("result.values")
  io.debug(result.values)


  // Manipular o resultado
   case result {
    Ok(returned) -> {
      // Acessar e mostrar values
      io.debug("result.count")
      io.debug(returned.count)

      io.debug("result.rows")
      io.debug(returned.rows)
      // Retornar os dados para visualização
      Ok(returned)
    }
    Error(err) -> Error(err)
  }
}