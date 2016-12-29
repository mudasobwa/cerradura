defmodule Cerradura.Images do
  @moduledoc """
  Collection of images.
  """

  @fields ~w|images size path|a

  def fields, do: @fields

  defstruct @fields

  @doc """
  Loads an EXIF data from the images, produces the map.

  ## Examples

      iex> exifs = Cerradura.Images.raw("test/images/**/*.jpg")
      ...> IO.inspect exifs |> Enum.take(1)
      iex> Enum.count(exifs)
      29
      iex> Enum.count(Enum.map(exifs, & &1.gps))
      29
  """
  def raw(path) do
    path
    |> Path.wildcard
    |> Stream.map(& Exexif.exif_from_jpeg_file!(&1))
    |> Enum.to_list
  end

  @doc """
  Constructs a `struct`, loading images EXIFs

  ## Examples

      iex> exifs = Cerradura.Images.new "test/images/**/*.jpg"
      iex> exifs.path
      "test/images/**/*.jpg"
      iex> exifs.size
      29
      iex> Enum.count(exifs.images)
      29

  """
  def new(path) do
    keys = Path.wildcard(path)
    values = keys
             |> Stream.map(& Exexif.exif_from_jpeg_file!(&1))
             |> Enum.to_list
    images = [keys, values]
             |> List.zip
             |> Enum.into(%{})
    %Cerradura.Images{images: images, size: Enum.count(images), path: path}
  end

  @doc """
  Constructs a set of `PhotoOverlay` objects

  ## Examples

      iex> "test/images/**/*.jpg"
      ...> |> Cerradura.Images.new
      ...> |> Cerradura.Images.to_kml
      ...> |> IO.puts
      :ok

  """
  # def to_kml([h | t]), do: [to_kml(h)] ++ to_kml(t)
  def to_kml(images) when is_list(images), do: Enum.map(images, & to_kml(&1))
  def to_kml(%Cerradura.Images{images: images}) do
    XmlBuilder.doc(
      :Document,
      images
      |> Enum.with_index
      |> Enum.map(fn {{path, exif}, idx} ->
       {:PhotoOverlay, %{id: "photo_#{idx}"}, [{:name, %{}, path}]}
      end)
    )
  end
end
