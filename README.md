# Ecto MySQL Match

Use MySQL match to enable fulltext search on one or more columns.

### Todo

- [ ] Support `WITH QUERY EXPANSION`
- [ ] Support `IN BOOLEAN MODE`
- [ ] Improve docs (examples) and tests

## Installation

The package can be installed by adding `:ecto_mysql_match` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_mysql_match, "~> 0.1.0"}
  ]
end
```

## Usage

To enable fulltext search you must first add the `FULLTEXT` index on one our more columns.

To add during table creation:
```sql
CREATE TABLE posts(
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255),
        description VARCHAR(255),
        FULLTEXT(title),
        FULLTEXT(title, description))
```

To add on existing table:
```sql
ALTER TABLE posts
        ADD FULLTEXT(title),
        ADD FULLTEXT(title, description)
```

Depending on your use case you probably want to add the index on separate columns or on a combination of them. Keep in mind that you need to provide the full list of columns when you add the index to multiple columns.

Once the index has been created you can use it in an Ecto query:


```ex
import Ecto.Query
import EctoMySQLMatch

query = from(p in "posts", where: match([p.title, p.description], "another"), select: p.title)
```

## Resources

- https://dev.mysql.com/doc/refman/8.0/en/fulltext-search.html
- https://mariadb.com/kb/en/full-text-index-overview/
 