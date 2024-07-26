import gleam/string
import gleam/io
import gleam/erlang
import gleam/result.{Result, Ok, Error}

pub fn start() {
    let connection = amqp_connection()
    case connection {
        Ok(conn) -> {
            let channel = amqp_channel(conn)
            case channel {
                Ok(ch) -> {
                    amqp_consume(ch)
                }
                Error(e) -> io.println(string.concat(["Erro ao abrir o canal: ", e]))
            }
        }
        Error(e) -> io.println(string.concat(["Erro ao abrir a conexão: ", e]))
    }
}

fn amqp_connection() -> Result(amqp_connection, String) {
        {ok, Hostname} = inet:gethostname(),
        User = <<"guest">>,
        Password = <<"guest">>,
        %% create a configuration map
        OpnConf = #{address => Hostname,
                    port => Port,
                    container_id => <<"test-container">>,
                    sasl => {plain, User, Password}},
        {ok, Connection} = amqp10_client:open_connection(OpnConf),
        {ok, Session} = amqp10_client:begin_session(Connection),
        SenderLinkName = <<"test-sender">>,
        {ok, Sender} = amqp10_client:attach_sender_link(Session, SenderLinkName, <<"a-queue-maybe">>),

}
