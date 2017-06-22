defmodule Blog.PageController do
  use Blog.Web, :controller

  def index(conn, _params) do
    posts = Repo.all(Blog.Post) |> Repo.preload([:comments])
    IO.puts "PAGE:"
    IO.inspect posts
    render conn, "index.html", posts: posts
  end
end
