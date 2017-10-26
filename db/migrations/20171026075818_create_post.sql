-- +micrate Up
CREATE TABLE posts (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR,
  body TEXT,
  published BOOL,
  user_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX user_id_idx ON posts (user_id);

-- +micrate Down
DROP TABLE IF EXISTS posts;
