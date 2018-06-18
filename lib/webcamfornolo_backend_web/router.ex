defmodule WebcamfornoloBackendWeb.Router do
  use WebcamfornoloBackendWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    # plug :accepts, ["json"]
    plug(Plug.Parsers, parsers: [:multipart, :json], pass: ["application/octet-stream"])
  end

  scope "/", WebcamfornoloBackendWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)

    get("/health", PageController, :health)
  end

  scope "/webcam", WebcamfornoloBackendWeb do
    # Use the default browser stack
    pipe_through(:api)

    get("/:id", WebcamController, :getWebcam)
    post("/:id", WebcamController, :saveWebcam)
  end

  scope "/weather", WebcamfornoloBackendWeb do
    # Use the default browser stack
    pipe_through(:api)

    get("/", WeatherController, :getWeather)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebcamfornoloBackendWeb do
  #   pipe_through :api
  # end
end
