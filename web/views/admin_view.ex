defmodule Blog.AdminView do
  use Blog.Web, :view

  def csrf_token(conn) do
    csrf = Plug.Conn.get_session(conn, "csrf_token")
    csrf2 = Map.get(conn.req_cookies, "_csrf_token")
    IO.puts "CSRF:"
    IO.inspect(csrf)
    IO.puts "CSRF2:"
    IO.inspect(conn)
    csrf
  end
end
