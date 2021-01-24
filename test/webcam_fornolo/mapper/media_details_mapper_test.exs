defmodule WebcamFornolo.Mapper.MediaFileMapperTest do
  use ExUnit.Case

  alias WebcamFornolo.Mapper.MediaFileMapper
  alias WebcamFornolo.Dal.Db.MediaFileEntity
  alias WebcamFornolo.Model.MediaFile

  test "MediaFileMapper should crete a MediaFile from a MediaFileEntity" do
    now = Timex.now()
    media_file_entity = %MediaFileEntity{
      id: 1,
      name: "name",
      path: "path",
      description: "description",
      content_type: "content type",
      created_at: now
    }
    expected = %MediaFile{
      id: 1,
      name: "name",
      description: "description",
      content_type: "content type",
      path: "path",
      created_at: now
    }
    assert MediaFileMapper.from(media_file_entity) == {:ok, expected}
  end

  test "MediaFileMapper should crete a MediaFile from a MediaFileEntity with a given path" do
    now = Timex.now()
    media_file_entity = %MediaFileEntity{
      id: 1,
      name: "name",
      path: "path",
      description: "description",
      content_type: "content type",
      created_at: now
    }
    new_path = "new/path"
    expected = %MediaFile{
      id: 1,
      name: "name",
      description: "description",
      content_type: "content type",
      path: new_path,
      created_at: now
    }
    assert MediaFileMapper.from(media_file_entity, new_path) == {:ok, expected}
  end

  test "MediaFileMapper should crete a MediaFile from a valid Map" do
    now = Timex.now()
    map = %{
      filename: "name",
      path: "path",
      description: "description",
      content_type: "content type"
    }
    expected = %MediaFile{
      id: 0,
      name: "name",
      description: "description",
      content_type: "content type",
      path: "path",
      created_at: now
    }
    {:ok, result} = MediaFileMapper.from(map)
    assert result.id == 0
    assert result.name == "name"
    assert result.description == "description"
    assert result.content_type == "content type"
    assert result.path == "path"
  end

  test "MediaFileMapper should fail to crete a MediaFile from an invalid Map" do
    now = Timex.now()
    invalid_map = %{
      filename: "name",
      description: "description",
      content_type: "content type"
    }
    expected = %MediaFile{
      id: 0,
      name: "name",
      description: "description",
      content_type: "content type",
      path: "path",
      created_at: now
    }
    assert MediaFileMapper.from(invalid_map) == :error
  end
end
