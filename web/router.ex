defmodule Blog.Router do
  use Blog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BasicAuth, username: "user", password: "secret"
  end

  scope "/", Blog do
    pipe_through [:browser, :auth]
    get "/", PostController, :index
    get "/log_in", PostController, :log_in

    resources "/posts", PostController do
      post "/comment", CommentController, :add_comment
    end
   # get  "/posts/:id", PostController, :show
   # post "/posts/:post_id/comment", PostController, :add_comment
  end

  # Other scopes may use custom stacks.
  # scope "/api", Blog do
  #   pipe_through :api
  # end
end
