defmodule EctoMySQLMatch do
  @moduledoc """
  Documentation for `EctoMySQLMatch`.
  """
  import Ecto.Query.API, only: [fragment: 1]

  @doc """
  Match against a string on a select list of fields (columns).

  This requires to have the FULLTEXT index on the selected columns.

  ## Options

    * `:search_modifier` apply a search modifier, the available options are:
      * `natural` which translates to `IN NATURAL LANGUAGE MODE` (default)
      * `natural_with_query_expansion` which translates to `IN NATURAL LANGUAGE MODE WITH QUERY EXPANSION`
      * `query_expansion` which translates to `WITH QUERY EXPANSION`

  ## Example

      from(p in "posts", where: match(p.title, "some title"), select: p.title)

      from(p in "posts", where: match([p.title, p.description], "some"), select: p.title)

  """
  defmacro match(fields, expr, opts \\ [search_modifier: :natural])

  defmacro match(fields, expr, opts) when is_list(fields) and is_binary(expr) do
    quote do
      fragment(unquote(match_query(fields, opts)), unquote_splicing(fields), unquote(expr))
    end
  end

  defmacro match(field, expr, opts) when is_binary(expr) do
    quote do
      fragment(unquote(match_query(field, opts)), unquote(field), unquote(expr))
    end
  end

  defp match_query(field_or_fields, opts) do
    match_params = match_params(field_or_fields)
    search_modifier = search_modifier(opts)

    "MATCH (#{match_params}) AGAINST (? #{search_modifier})"
  end

  defp match_params(fields) when is_list(fields) do
    fields_count = length(fields)
    [match_param() | List.duplicate(", ?", fields_count - 1)]
  end

  defp match_params(_field), do: match_param()

  defp match_param, do: "?"

  defp search_modifier(opts) when is_list(opts) do
    search_modifier = Keyword.get(opts, :search_modifier)
    search_modifier(search_modifier)
  end

  defp search_modifier(:natural), do: "IN NATURAL LANGUAGE MODE"

  defp search_modifier(:natural_with_query_expansion),
    do: "#{search_modifier(:natural)} #{search_modifier(:query_expansion)}"

  defp search_modifier(:query_expansion), do: "WITH QUERY EXPANSION"
end
