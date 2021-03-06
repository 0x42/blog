defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.Comment
  alias Blog.Post

#  plug :scrub_params, "comment" when action in [:add_comment]
  def index(conn, _params) do
    posts = Repo.all(Post) |> Repo.preload([:comments])
    auth = BasicAuth.is_auth(conn)
    render(conn, "index.html", posts: posts, admin: auth)
  end

  def new(conn, _params) do
    env = System.get_env()
#    IO.puts "ENV:"
#    IO.inspect env
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)
      case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        #err_msg = Tools.stringify changeset.errors
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(Post, id) |> Repo.preload([:comments])
    changeset = Comment.changeset(%Comment{})
    #TODO delete is_auth
    auth = BasicAuth.is_auth(conn)
    render conn, "show.html", post: post , changeset: changeset, admin: auth
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  def add_comment(conn, params = %{"comment" => comment, "post_id" => post_id}) do
    new_comment =  Map.put(comment, "post_id", post_id)
    changeset = Comment.changeset(%Comment{}, new_comment)
    post = Post |> Repo.get(post_id) |> Repo.preload([:comments])
    if changeset.valid? do
      Repo.insert(changeset)
      conn
      |> put_flash(:info, "Comment added.")
      |> redirect(to: post_path(conn, :show, post))
    else
      render(conn, "show.html", post: post, changeset: changeset)
    end
  end

end
