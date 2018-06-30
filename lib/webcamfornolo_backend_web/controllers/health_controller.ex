defmodule WebcamfornoloBackendWeb.HealthController do
  use WebcamfornoloBackendWeb, :controller

  def health(conn, _params) do
    json(conn, %{status: "feeling good!"})
  end
end
