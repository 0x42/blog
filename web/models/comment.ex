defmodule Blog.Comment do
  use Blog.Web, :model

  schema "comments" do
    field :user_name, :string
    field :body, :string
    belongs_to :post, Blog.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_name, :body])
    |> validate_required([:user_name, :body])
  end
end
