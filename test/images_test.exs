defmodule Cerradura.Images.Test do
  use ExUnit.Case
  doctest Cerradura.Images

  @images_dir "test/images"

  test "there are images in the respective folder" do
    with {:ok, list} <- File.ls(@images_dir) do
      assert Enum.count(list) == 29
      assert list |> Enum.map(& String.slice(&1, 0..11)) |> Enum.uniq == ~w|IMG_20160522|
    end
  end

  test "we read an exif/gps information asynchronously" do
    exifs = Cerradura.Images.new "#{@images_dir}/**/*.jpg"
    assert exifs.size == 29
    assert exifs.path == "#{@images_dir}/**/*.jpg"
    assert Enum.count(exifs.images) == 29
  end
end
