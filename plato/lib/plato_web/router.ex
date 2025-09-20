defmodule PlatoWeb.Router do
  use PlatoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PlatoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlatoWeb do
    pipe_through :browser

    live "/", HomeLive, :index

    live "/students", StudentLive.Index, :index
    live "/students/new", StudentLive.Form, :new
    live "/students/:id", StudentLive.Show, :show
    live "/students/:id/edit", StudentLive.Form, :edit

    live "/problems", ProblemLive.Index, :index
    live "/problems/new", ProblemLive.Form, :new
    live "/problems/:id", ProblemLive.Show, :show
    live "/problems/:id/edit", ProblemLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlatoWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:plato, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PlatoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
