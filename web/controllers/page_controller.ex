defmodule Blog.PageController do
  use Blog.Web, :controller

  def index(conn, _params) do
    posts = Repo.all Blog.Post
    render conn, "index.html", posts: posts
  end
end
