defmodule WebcamFornolo.Dal.Db.MediaFileEntityTest do
  use ExUnit.Case

  alias WebcamFornolo.Dal.Db.MediaFileEntity
  alias WebcamFornolo.Model.MediaFile
  alias WebcamFornolo.Util.DateTimeUtil

  test "MediaFileEntity should create a valid Changeset from a MediaFile" do
    {:ok, media_file} =
      MediaFile.create(%{
        id: 1,
        name: "mediaFileName",
        description: "media file description",
        content_type: "jpg",
        path: "path/to/media",
        created_at: DateTimeUtil.now() |> DateTime.truncate(:second)
      })

    changeset = MediaFileEntity.from(media_file)
    assert changeset.valid? == true
    assert Enum.empty?(changeset.errors) == true
    assert {1, changeset.changes} == Map.from_struct(media_file) |> Map.pop!(:id)
  end

  test "MediaFileEntity should create a valid Changeset from a MediaFileEntity and some changes" do
    media_file_entity = %MediaFileEntity{
      name: "mediaName",
      path: "path/to/media",
      description: "media description",
      content_type: "jpg",
      created_at: DateTimeUtil.now() |> DateTime.truncate(:second)
    }

    changes = %{
      name: "newMediaName",
      path: "new/path/to/media",
      description: "new media description",
      content_type: "png",
      created_at: DateTimeUtil.now() |> DateTime.truncate(:second) |> DateTime.add(3600, :second)
    }

    changeset = MediaFileEntity.changeset(media_file_entity, changes)

    assert changeset.valid? == true
    assert Enum.empty?(changeset.errors) == true
    assert changeset.changes == changes
  end

  test "MediaFileEntity should fail to create a Changeset if data is not valid" do
    media_file_entity = %MediaFileEntity{
      name: "mediaName",
      path: "path/to/media",
      description: "media description",
      content_type: "jpg",
      created_at: DateTimeUtil.now() |> DateTime.truncate(:second)
    }

    changes = %{
      name: 123,
      path: true,
      description: 1234,
      content_type: :png,
      created_at: "date"
    }

    changeset = MediaFileEntity.changeset(media_file_entity, changes)

    assert changeset.valid? == false

    assert changeset.errors == [
             name: {"is invalid", [type: :string, validation: :cast]},
             content_type: {"is invalid", [type: :string, validation: :cast]},
             path: {"is invalid", [type: :string, validation: :cast]},
             created_at: {"is invalid", [type: :utc_datetime, validation: :cast]},
             description: {"is invalid", [type: :string, validation: :cast]}
           ]
  end
end
