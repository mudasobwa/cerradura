defmodule Cerradura.Images.Test do
  use ExUnit.Case
  doctest Cerradura.Images

  @images_dir "test/images"

  test "there are images in the respective folder" do
    with {:ok, list} <- File.ls(@images_dir) do
      assert Enum.count(list) == 29
      assert list == ~w|
        IMG_20160522_123640.jpg
        IMG_20160522_123153.jpg
        IMG_20160522_121928.jpg
        IMG_20160522_123632.jpg
        IMG_20160522_121835.jpg
        IMG_20160522_123208.jpg
        IMG_20160522_122319.jpg
        IMG_20160522_121534.jpg
        IMG_20160522_123013.jpg
        IMG_20160522_123944.jpg
        IMG_20160522_121735.jpg
        IMG_20160522_125339.jpg
        IMG_20160522_123915.jpg
        IMG_20160522_125042.jpg
        IMG_20160522_125013.jpg
        IMG_20160522_122115.jpg
        IMG_20160522_122643.jpg
        IMG_20160522_123537.jpg
        IMG_20160522_121751.jpg
        IMG_20160522_125650.jpg
        IMG_20160522_121952.jpg
        IMG_20160522_130417.jpg
        IMG_20160522_122042.jpg
        IMG_20160522_122347.jpg
        IMG_20160522_122102.jpg
        IMG_20160522_122131.jpg
        IMG_20160522_121806.jpg
        IMG_20160522_123823.jpg
        IMG_20160522_122352.jpg
      |
    end
  end

  test "we read an exif/gps information asynchronously" do
    exifs = Cerradura.Images.new "#{@images_dir}/**/*.jpg"
    assert exifs.size == 29
    assert exifs.path == "#{@images_dir}/**/*.jpg"
    assert Enum.count(exifs.images) == 29
  end
end
