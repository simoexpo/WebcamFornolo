defmodule WebcamfornoloBackendWeb.HealthControllerTest do
  use WebcamfornoloBackendWeb.ConnCase

  test "GET /health", %{conn: conn} do
    conn = get(conn, "/health")
    assert json_response(conn, 200) == %{"status" => "feeling good!"}
  end
end
