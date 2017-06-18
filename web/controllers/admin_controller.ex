defmodule Blog.AdminController do
  use Blog.Web, :controller
  import Plug.Conn
  
  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    csrf = Plug.Conn.get_session(conn, :csrf_token)
    csrf2 = Map.get(conn.req_cookies, "_csrf_token")
    IO.puts "> CSRF:"
    IO.inspect csrf
    IO.puts "> CSRF2:"
    IO.inspect csrf2
    render conn, "new.html"
  end
  
  def create(conn, _params) do
    
    render conn, "index.html"
  end
end
