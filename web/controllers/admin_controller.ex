defmodule Blog.AdminController do
  use Blog.Web, :controller
  import Plug.Conn
  alias Blog.Post

  
  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    render conn, "new.html", error: nil
  end
  
  def create(conn, params = %{"admin_post" => new_post}) do
    changeset = Post.changeset %Post{}, new_post

    case Repo.insert changeset do
      {:ok, _schema} -> redirect conn, to: "/admin"
      {:error, chg_set} ->
        err = chg_set.errors
        IO.inspect err
        render conn, "new.html", error: err
    end
  end
end
