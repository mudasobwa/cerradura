defmodule Cerradura.Image do
  require Cerradura.Utils.Converters, as: C

  @moduledoc """
  Here is how it comes from `Exexif` library:

      gps: %Exexif.Data.Gps{gps_altitude: 25, gps_altitude_ref: 0,
        gps_area_information: nil, gps_date_stamp: "2016:05:22",
        gps_dest_bearing: nil, gps_dest_bearing_ref: nil, gps_dest_distance: nil,
        gps_dest_distance_ref: nil, gps_dest_latitude: nil,
        gps_dest_latitude_ref: nil, gps_dest_longitude: nil,
        gps_dest_longitude_ref: nil, gps_differential: nil, gps_dop: nil,
        gps_h_positioning_errorl: nil, gps_img_direction: 81.13,
        gps_img_direction_ref: "M", gps_latitude: [41, 22, 8.563],
        gps_latitude_ref: "N", gps_longitude: [2, 10, 19.746],
        gps_longitude_ref: "E", gps_map_datum: nil, gps_measure_mode: nil,
        gps_processing_method: 0, gps_satellites: nil, gps_speed: nil,
        gps_speed_ref: nil, gps_status: nil, gps_time_stamp: [10, 15, 34],
        gps_track: nil, gps_track_ref: nil, gps_version_id: nil}
  """

  @fields ~w|gps address addresses|a

  def fields, do: @fields

  defstruct @fields

  ##############################################################################

  def update(changeset, data \\ %Cerradura.Image{})

  def update(%Exexif.Data.Gps{} = changeset, %Cerradura.Image{} = data) do
    %Cerradura.Image{data | gps: changeset}
  end

  def update(changeset, %Cerradura.Image{} = data) when is_map(changeset) do
    if Map.has_key?(changeset, :gps), do: %Cerradura.Image{data | gps: changeset.gps}, else: data
  end

  def update(changeset, %Cerradura.Image{} = data) when is_list(changeset) do
    update(data, Enum.into(changeset, %{}))
  end

  ##############################################################################

  @doc """
  Produces a new image struct out of file given

  ## Examples

      iex> image = "test/images/IMG_20160522_122319.jpg"
      ...> exif = Cerradura.Image.new(image)
      ...> exif.gps.gps_date_stamp
      "2016:05:22"
  """
  def new(file) when is_binary(file) do
    file
    |> Exexif.exif_from_jpeg_file!
    |> update
  end

  @doc """
  Retrieves the address from remote. NB! Blocking!

  ## Examples

      iex> image = "test/images/IMG_20160522_122319.jpg"
      ...> image = image |> Cerradura.Image.new |> Cerradura.Image.address!
      ...> IO.puts inspect(image.address)
      :ok
      iex> image.address.location.city
      "BCN"
  """
  def address!(%Cerradura.Image{gps: gps, address: nil} = data) do
    case {C.latlon(gps.gps_latitude), C.latlon(gps.gps_longitude)} do
      {nil, nil} -> data
      {nil, _}   -> data
      {_, nil}   -> data
      {lat, lon} ->
        with {:ok, address} = Geocoder.call_list({lat, lon}) do
          {[h], t} = Enum.split(address, 1)
          %Cerradura.Image{data | address: h, addresses: (if Enum.empty?(t), do: nil, else: t)}
        end
    end
  end
end
