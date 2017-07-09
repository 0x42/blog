defmodule Blog.Post do
  use Blog.Web, :model
  import Ecto.Query

  schema "posts" do
    field :title, :string
    field :body, :string

    has_many :comments, Blog.Comment, on_delete: :delete_all

    timestamps()
  end

  @doc """

  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body])
    |> unique_constraint(:title, name: :posts_unique_field)
    |> validate_required([:title, :body])
  end

  @doc """ 

  """
  def count_comments(query) do
    0
    # from p in query,
    #   group_by: p.id,
    #   left_join: c in assoc(p, :comments),
    #   select: {p, count(c.id)}
  end
end
