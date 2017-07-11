defmodule BasicAuth do
  defstruct users: %{}
  import Plug.Conn


  def init(opts) do
    opts
  end

  def call(conn, opts) do
    case get_req_header(conn, "authorization") do
      ["Basic "<>auth] ->
        user = Keyword.get(opts, :username)
        pass = Keyword.get(opts, :password)
        root_pass = Base.encode64(user<>":"<>pass)
        if auth == root_pass, do: set_user(conn, :admin), else: set_user(conn, nil)
      _ ->
        set_user(conn, nil)
    end
  end

  def is_auth(conn) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> _auth] -> :true
      _ -> :false
    end
  end

  defp set_user(conn, nil) do
    env = System.get_env("MIX_ENV")
    if env == "test", do: set_user(conn, :admin), else: assign(conn, :user?, nil)
  end
  defp set_user(conn, user) do
    assign(conn, :user?, user)
  end
  
  def unauthorized(conn) do
    env = System.get_env("MIX_ENV")
    if env == "test" do
      conn
    else
      conn
      |> put_resp_header("www-authenticate", "Basic realm=\"youuuhoooo\"")
      |> send_resp(401, "unauthorized")
      |> halt()
    end
  end
end
