defmodule TodoProjectWeb.Router do
  use TodoProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TodoProjectWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TodoProjectWeb.Pipeline
    plug TodoProjectWeb.Plugs.LoggedInRolePlug
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :allowed_for_users do
    plug TodoProjectWeb.Plugs.AuthorizationPlug, ["Admin", "Business Analyst", "User"]
  end

  pipeline :allowed_for_business_analysts do
    plug TodoProjectWeb.Plugs.AuthorizationPlug, ["Admin", "Business Analyst"]
  end

  pipeline :allowed_for_admins do
    plug TodoProjectWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  ### Everyone
  scope "/", TodoProjectWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/register", UserController, :register_new
    post "/register", UserController, :register_create
  end

  ### Users
  scope "/", TodoProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    resources "/todos", TodoController
    get "/user_scope", PageController, :user_index
  end

  ### Business Analysts
  scope "/", TodoProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_business_analysts]

    get "/business_analyst_scope", PageController, :business_analyst_index
  end

  ### Admins
  scope "/admin", TodoProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    resources "/users", UserController
    # resources "/todos", TodoController
    resources "/categories", CategoryController
    resources "/statuses", StatusController
    get "/", PageController, :admin_index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TodoProjectWeb do
  #   pipe_through :api
  # end
  scope "/api", TodoProjectWeb do
    pipe_through :api
    resources "/todos", TodoApiController, except: [:new, :edit]
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
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TodoProjectWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
