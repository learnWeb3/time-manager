defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {TimeManagerWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  # Other scopes may use custom stacks.
  scope "/api", TimeManagerWeb do
    pipe_through(:api)
    resources("/schedules", ScheduleController, [:create, :update, :index, :delete])
    resources("/users", UserController, except: [:new, :edit])
    get("/status/:userId", StatusController, :show)
    get("/status", StatusController, :index)
    get("/workingtimes/:userId", WorkingTimeController, :index)
    post("/workingtimes/:userId", WorkingTimeController, :create)
    delete("/workingtimes/:id", WorkingTimeController, :delete)
    post("/clocks/:userId", ClockController, :create)
    get("/clocks/presence", ClockController, :presence)
    get("/clocks/:userId", ClockController, :user_clocks)
    post("/sessions/login", SessionController, :login)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: TimeManagerWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
