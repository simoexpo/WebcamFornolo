defmodule WebcamfornoloBackend.Repo do
  use Ecto.Repo,
    otp_app: :webcamfornolo_backend,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query

  def paginated(queryable, page, rpp) do
    offset = page * rpp

    items =
      queryable
      |> order_by(desc: :created_at)
      |> limit(^rpp)
      |> offset(^offset)
      |> all()

    count =
      queryable
      |> select([e], count(e.id))
      |> one()

    total_pages = trunc(Float.ceil(count / rpp))
    {items, total_pages}
  end
end
