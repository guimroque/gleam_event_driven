import gleam/io
import db/config.{connect}
import gleam/dynamic.{type Dynamic, dynamic}
import gleam/pgo.{
  type QueryError,
  type Returned,
}
import db/repositories/users/types.{type User}

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

pub fn insert_user_repository(user: User) -> Nil {
  // Conectar ao banco de dados
  let db = connect()
  
  // Definir a consulta SQL para inserir um usuário
  let sql = "
    INSERT INTO users (
      id, name, email, public_key, status, balance, currency, created_at, updated_at
    ) 
    VALUES (
      $1, $2, $3, $4, $5, $6, $7, $8, $9
    )
  "

  // Executar a consulta
  let _result = pgo.execute(sql, db, [
    pgo.text(user.id),
    pgo.text(user.name),
    pgo.text(user.email),
    pgo.text(user.public_key),
    pgo.text(user.status),
    pgo.float(user.balance),
    pgo.text(user.currency),
    pgo.text(user.created_at),
    pgo.text(user.updated_at),
  ], dynamic.dynamic)

  // Desconectar do banco de dados
  pgo.disconnect(db)

  // Retornar sucesso
  Nil
}