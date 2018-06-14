defmodule WebcamfornoloBackendWeb.Router do
  use WebcamfornoloBackendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    #plug :accepts, ["json"]
    plug Plug.Parsers, parsers: [:multipart, :json], pass: ["application/octet-stream"]
  end

  scope "/", WebcamfornoloBackendWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/health", PageController, :health
  end

  scope "/webcam", WebcamfornoloBackendWeb do
    pipe_through :api # Use the default browser stack

    get "/:id", WebcamController, :getWebcam
    post "/:id", WebcamController, :saveWebcam

  end

  # Other scopes may use custom stacks.
  # scope "/api", WebcamfornoloBackendWeb do
  #   pipe_through :api
  # end
end
