defmodule Blog.CommentController do
  use Blog.Web, :controller

  alias Blog.Comment
  alias Blog.Post
  
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
