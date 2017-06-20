defmodule Blog.AdminController do
  use Blog.Web, :controller
  import Plug.Conn
  import Tools
  alias Blog.Post


  def index(conn, _params) do
    posts = Repo.all Post
    render conn, "index.html", posts: posts
  end

  def new(conn, _params) do
    render conn, "new.html", error: nil
  end

  def create(conn, params = %{"admin_post" => new_post}) do
    changeset = Post.changeset %Post{}, new_post

    case Repo.insert changeset do
      {:ok, _schema} -> redirect conn, to: "/admin"
      {:error, chg_set} ->
        render conn, "new.html", error: stringify(chg_set.errors)
    end
  end

  def delete(conn, params = %{"id" => id}) do
    try do
      Post |> Repo.get!(id) |> Repo.delete!
    rescue
      e ->
        err_msg = stringify({"DELETE POST ERROR", e})
        conn = put_flash(conn, :error, err_msg)
    end
    redirect conn, to: "/admin"
  end
  
  def show(conn, params = %{"id" => id}) do
    IO.puts "SHOW"
    post = Post |> Repo.get!(id)
    render conn, "show.html", post: post
  end
  
  def update(conn, _params) do
    IO.puts "UPDATE"
    redirect conn, to: "/admin"
  end
end
