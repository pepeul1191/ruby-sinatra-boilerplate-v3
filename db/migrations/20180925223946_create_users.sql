-- migrate:up

CREATE TABLE users(
	id	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(40) NOT NULL,
  user VARCHAR(20) NOT NULL,
  password VARCHAR(30) NOT NULL,
  email VARCHAR(30) NOT NULL
)

-- migrate:down

DROP TABLE IF EXISTS users;
