defmodule WebcamFornolo.Dal.Db.RepoTest do
  use WebcamFornolo.RepoCase

  import WebcamFornolo.MediaFileEntityFactory

  alias WebcamFornolo.Dal.Db.Repo
  alias WebcamFornolo.Dal.Db.MediaFileEntity

  test "Repo should be able to retrieve data paginated sorted by creation date" do
    media_file_entities =
      Range.new(0, 9)
      |> Enum.map(fn _ -> a_media_file() end)
      |> Enum.map(&insert!/1)

    total_page = 4

    {page_1, ^total_page} = Repo.paginated(MediaFileEntity, 0, 3)
    {page_2, ^total_page} = Repo.paginated(MediaFileEntity, 1, 3)
    {page_3, ^total_page} = Repo.paginated(MediaFileEntity, 2, 3)
    {page_4, ^total_page} = Repo.paginated(MediaFileEntity, 3, 3)

    assert page_1 ++ page_2 ++ page_3 ++ page_4 == Enum.sort(media_file_entities, fn x, y -> x.created_at >= y.created_at end)
  end
end
