resource "sql_migrate" "db" {
  migration { 
    id = "1"
    up = <<SQL
CREATE TABLE users (
	user_id integer unique,
	name    varchar(40),
	email   varchar(40)
);
SQL

    down = "DROP TABLE IF EXISTS users;"
  }

  migration {
    id = "2"
    up   = "INSERT INTO users VALUES (1, 'Paul Tyng', 'paul@example.com');"
    down = "DELETE FROM users WHERE user_id = 1;"
  }
}

data "sql_query" "users" {
  # run this query after the migration
  depends_on = [sql_migrate.db]

  query = "select * from users"
}

output "rowcount" {
  value = length(data.sql_query.users.result)
}
