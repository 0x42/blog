defmodule Blog.HelloController do
  use Blog.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
  
  def show(conn, %{"messanger" => messanger}) do
    render conn, "show.html", messanger: messanger
  end
end
