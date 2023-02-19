defmodule EctoMySQLMatch.TestRepo do
  use Ecto.Repo,
    otp_app: :ecto_mysql_match,
    adapter: Ecto.Adapters.MyXQL

  def init(_context, opts) do
    opts = [url: database_url()] ++ opts
    {:ok, opts}
  end

  defp database_url do
    database = System.get_env("MYSQL_DATABASE", "ecto_mysql_match_test")
    username = System.get_env("MYSQL_USER", "root")
    password = System.get_env("MYSQL_PASSWORD", "root")
    hostname = System.get_env("MYSQL_HOST", "localhost")
    port = System.get_env("MYSQL_PORT", "3306")

    "ecto://#{username}:#{password}@#{hostname}:#{port}/#{database}"
  end
end
