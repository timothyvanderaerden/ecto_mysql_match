defmodule EctoMySQLMatch do
  @moduledoc """
  Documentation for `EctoMySQLMatch`.
  """
  import Ecto.Query.API, only: [fragment: 1]

  @doc """
  Match against a string on a select list of fields (columns).

  This requires to have the FULLTEXT index on the selected columns.

  ## Example

      from(p in "posts", where: match(p.title, "some title"), select: p.title)

      from(p in "posts", where: match([p.title, p.description], "some"), select: p.title)

  """
  defmacro match(fields, search_modifier) when is_list(fields) and is_binary(search_modifier) do
    quote do
      fragment(unquote(match_query(fields)), unquote_splicing(fields), unquote(search_modifier))
    end
  end

  defmacro match(field, search_modifier) when is_binary(search_modifier) do
    quote do
      fragment(unquote(match_query(field)), unquote(field), unquote(search_modifier))
    end
  end

  defp match_query(field_or_fields) do
    match_params = match_params(field_or_fields)
    "MATCH (#{match_params}) AGAINST (?)"
  end

  defp match_params(fields) when is_list(fields) do
    fields_count = length(fields)
    [match_param() | List.duplicate(", ?", fields_count - 1)]
  end

  defp match_params(_field), do: match_param()

  defp match_param, do: "?"
end
