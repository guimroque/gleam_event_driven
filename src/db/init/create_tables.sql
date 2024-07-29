-- create_tables.sql
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    public_key VARCHAR(255),
    status VARCHAR(50),
    balance DECIMAL(10, 2),
    currency VARCHAR(10),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
