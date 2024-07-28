import app/routes/router
import gleam/http/elli

// Start it on port 3000 using the Elli web server
pub fn main() {
 elli.become(router.run, on_port: 3000)
}

// connecta
// abre um canal
// declara queue