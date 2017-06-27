defmodule Blog.Repo.Migrations.AddUniqueField do
  use Ecto.Migration

  def change do
    create unique_index(:posts, [:title], name: :posts_unique_field)
  end
end
