defmodule WebcamfornoloBackendWeb.Router do
  use WebcamfornoloBackendWeb, :router

  pipeline :api do
    # plug :accepts, ["json"]
    # plug parser :json
    plug(Plug.Parsers, parsers: [:multipart], pass: ["application/octet-stream"])
  end

  scope "/", WebcamfornoloBackendWeb do
    pipe_through(:api)

    get("/health", HealthController, :health)
  end

  scope "/webcam", WebcamfornoloBackendWeb do
    pipe_through(:api)

    get("/:id", WebcamController, :get_webcam)
    post("/:id", WebcamController, :save_webcam)
  end

  scope "/weather", WebcamfornoloBackendWeb do
    pipe_through(:api)

    get("/", WeatherController, :get_weather)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebcamfornoloBackendWeb do
  #   pipe_through :api
  # end
end
