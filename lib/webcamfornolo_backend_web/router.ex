defmodule WebcamfornoloBackendWeb.Router do
  use WebcamfornoloBackendWeb, :router
  alias WebcamfornoloBackendWeb.Auth

  pipeline :authorization do
    plug(Auth)
  end

  scope "/health", WebcamfornoloBackendWeb do
    get("/", HealthController, :health)
  end

  scope "/webcam", WebcamfornoloBackendWeb do
    get("/:id", WebcamController, :get_webcam)

    pipe_through(:authorization)
    post("/:id", WebcamController, :save_webcam)
  end

  scope "/weather", WebcamfornoloBackendWeb do
    get("/", WeatherController, :get_weather)
  end

  scope "/media", WebcamfornoloBackendWeb do
    get("/", MediaController, :get_media_paginated)

    pipe_through(:authorization)
    post("/", MediaController, :save_media)
    delete("/:id", MediaController, :delete_media)
    options("/:id", CommonController, :options)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebcamfornoloBackendWeb do
  #   pipe_through :api
  # end
end
