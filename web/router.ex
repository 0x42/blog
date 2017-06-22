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
    pipe_through :browser # Use the default browser stack
    get "/", PostController, :index_share
    get "/posts/:id", PostController, :show_share
  end

  scope "/admin", Blog do
    pipe_through [:browser, :auth]

    resources "/posts", PostController do
      post "/comment", PostController, :add_comment
    end

    get    "/",    PostController, :index
    # get    "/new", AdminController, :new
    # post   "/new", AdminController, :create
    # delete "/:id", AdminController, :delete
    # get    "/:id", AdminController, :show
    # put    "/:id", AdminController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", Blog do
  #   pipe_through :api
  # end
end
