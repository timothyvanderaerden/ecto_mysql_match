# Ecto MySQL Match

[![CI](https://github.com/timothyvanderaerden/ecto_mysql_extras/actions/workflows/ci.yml/badge.svg)](https://github.com/timothyvanderaerden/ecto_mysql_match/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/timothyvanderaerden/ecto_mysql_match/branch/main/graph/badge.svg?token=IJMNEMI6CE)](https://codecov.io/gh/timothyvanderaerden/ecto_mysql_match)
[![Module Version](https://img.shields.io/hexpm/v/ecto_mysql_match.svg)](https://hex.pm/packages/ecto_mysql_match)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ecto_mysql_match/)
[![Total Download](https://img.shields.io/hexpm/dt/ecto_mysql_match.svg)](https://hex.pm/packages/ecto_mysql_match)
[![License](https://img.shields.io/hexpm/l/ecto_mysql_match.svg)](https://github.com/timothyvanderaerden/ecto_mysql_match/blob/main/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/timothyvanderaerden/ecto_mysql_match.svg)](https://github.com/timothyvanderaerden/ecto_mysql_match/commits/main)

Use MySQL match to enable fulltext search on one or more columns.

### Todo

- Support `IN BOOLEAN MODE`
- Improve docs (examples) and tests

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

To enable fulltext search you must first add the `FULLTEXT` index on one our more columns. The index can only be set on text columns: `char`, `varchar` and `text`.

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

from(p in "posts", where: match(p.title, "another"), select: p.title)

from(p in "posts", where: match([p.title, p.description], "another"), select: p.title)
```

## Resources

- https://dev.mysql.com/doc/refman/8.0/en/fulltext-search.html
- https://mariadb.com/kb/en/full-text-index-overview/
 