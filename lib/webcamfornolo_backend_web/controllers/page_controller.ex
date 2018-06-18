defmodule WebcamfornoloBackendWeb.PageController do
  use WebcamfornoloBackendWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def health(conn, _params) do
    json(conn, %{status: "feeling good!"})
  end
end
