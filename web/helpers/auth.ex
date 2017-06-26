defmodule BasicAuth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    IO.inspect conn
    case get_req_header(conn, "authorization") do
      ["Basic "<>auth] ->
        user = Keyword.get(opts, :username)
        pass = Keyword.get(opts, :password)
        root_pass = Base.encode64(user<>":"<>pass)
        if auth == root_pass, do: conn, else: unauthorized(conn)
      _ ->
        unauthorized(conn)
    end
  end

  def is_auth(conn) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> _auth] -> :true
      _ -> :false
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_resp_header("www-authenticate", "Basic realm=\"youuuhoooo\"")
    |> send_resp(401, "unauthorized")
    |> halt()
  end
end
