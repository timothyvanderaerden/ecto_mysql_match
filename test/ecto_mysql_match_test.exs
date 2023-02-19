defmodule EctoMySQLMatchTest do
  use ExUnit.Case
  doctest EctoMySQLMatch

  import Ecto.Query
  import EctoMySQLMatch

  describe "match" do
    test "match/2 returns valid query" do
      query = from(p in "posts", where: match(:title, "some title"))

      assert {:fragment, [],
              [
                raw: "MATCH (",
                expr: :title,
                raw: ") AGAINST (",
                expr: "some title",
                raw: ")"
              ]} == hd(query.wheres).expr

      query = from(p in "posts", where: match(p.title, "some title"))

      assert {:fragment, [],
              [
                raw: "MATCH (",
                expr: {{:., [], [{:&, [], [0]}, :title]}, [], []},
                raw: ") AGAINST (",
                expr: "some title",
                raw: ")"
              ]} == hd(query.wheres).expr
    end

    test "match/2 returns valid query and multiple fields" do
      query = from(p in "posts", where: match([:title, :description], "some title"))

      assert {:fragment, [],
              [
                {:raw, "MATCH ("},
                {:expr, :title},
                {:raw, ", "},
                {:expr, :description},
                {:raw, ") AGAINST ("},
                {:expr, "some title"},
                {:raw, ")"}
              ]} == hd(query.wheres).expr

      query = from(p in "posts", where: match([p.title, p.description], "some title"))

      assert {
               :fragment,
               [],
               [
                 {:raw, "MATCH ("},
                 {:expr, {{:., [], [{:&, [], [0]}, :title]}, [], []}},
                 {:raw, ", "},
                 {:expr, {{:., [], [{:&, [], [0]}, :description]}, [], []}},
                 {:raw, ") AGAINST ("},
                 {:expr, "some title"},
                 {:raw, ")"}
               ]
             } == hd(query.wheres).expr
    end
  end

  describe "integrated tests" do
    @describetag :integration
    alias EctoMySQLMatch.TestRepo

    setup do
      start_supervised!(TestRepo)

      TestRepo.query("DROP TABLE IF EXISTS posts")

      TestRepo.query("""
      CREATE TABLE posts(
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255),
        description VARCHAR(255),
        FULLTEXT(title),
        FULLTEXT(title, description))
      """)

      TestRepo.query("INSERT INTO posts(title, description) VALUES (?, ?)", [
        "some title",
        "some description"
      ])

      TestRepo.query("INSERT INTO posts(title, description) VALUES (?, ?)", [
        "another title",
        "another description"
      ])

      :ok
    end

    test "match/2 returns valid rows" do
      query = from(p in "posts", where: match(p.title, "some"), select: p.title)

      assert ["some title"] = TestRepo.all(query)
    end

    test "match/2 returns valid rows with multiple columns" do
      query =
        from(p in "posts", where: match([p.title, p.description], "another"), select: p.title)

      assert ["another title"] = TestRepo.all(query)
    end
  end
end
