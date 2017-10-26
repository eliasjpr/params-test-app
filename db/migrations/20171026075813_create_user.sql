-- +micrate Up
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR,
  encrypted_password VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
DROP TABLE IF EXISTS users;
