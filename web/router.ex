defmodule Blog.Router do
  use Blog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session    # <-
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Blog do
    pipe_through :browser # Use the default browser stack

    resources "/posts", PostController do
      post "/comment", PostController, :add_comment
    end

    get "/", PageController, :index
  end

  scope "/admin", Blog do
    pipe_through :browser

    get  "/",    AdminController, :index
    get  "/new", AdminController, :new
    post "/new", AdminController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", Blog do
  #   pipe_through :api
  # end
end
