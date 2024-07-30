-- create_tables.sql
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    public_key VARCHAR(255),
    status VARCHAR(50),
    balance DECIMAL(10, 2),
    currency VARCHAR(10),
    reason VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
