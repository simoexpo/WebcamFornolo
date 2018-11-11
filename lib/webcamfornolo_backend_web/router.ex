defmodule WebcamfornoloBackendWeb.Router do
  use WebcamfornoloBackendWeb, :router
  alias WebcamfornoloBackendWeb.Auth

  pipeline :api do
    # plug :accepts, ["json"]
    # plug parser :json
    plug(Plug.Parsers, parsers: [:multipart], pass: ["application/octet-stream"])
  end

  pipeline :authorization do
    plug(Auth)
  end

  scope "/health", WebcamfornoloBackendWeb do
    pipe_through(:api)
    get("/", HealthController, :health)
  end

  scope "/webcam", WebcamfornoloBackendWeb do
    pipe_through(:api)
    get("/:id", WebcamController, :get_webcam)

    pipe_through(:authorization)
    post("/:id", WebcamController, :save_webcam)
  end

  scope "/weather", WebcamfornoloBackendWeb do
    pipe_through(:api)
    get("/", WeatherController, :get_weather)
  end

  scope "/media", WebcamfornoloBackendWeb do
    pipe_through(:api)
    get("/", MediaController, :get_media_paginated)

    pipe_through(:authorization)
    post("/", MediaController, :save_media)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebcamfornoloBackendWeb do
  #   pipe_through :api
  # end
end
