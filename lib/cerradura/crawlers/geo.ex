defmodule Cerradura.Crawlers.Geo do
  @moduledoc """
  Basic crawler for GEO lookup.
  """

  @behaviour Cerradura.Crawler

  @doc """
  Expects the `latitude` and `longitude` as returned by `Exexif`,
    returns the map of main address and the rest of addresses.
  """
  def crawl(%Exexif.Data.Gps{gps_latitude: lat, gps_longitude: lon} = data, opts \\ []) do
    case Cerradura.Utils.Converters.latlon({lat, lon}) do
      {nil, nil} -> data
      {nil, _}   -> data
      {_, nil}   -> data
      {lat, lon} ->
        with {:ok, address} = Geocoder.call_list({lat, lon}) do
          {[h], t} = Enum.split(address, 1)
          %{address: h, addresses: (if Enum.empty?(t), do: nil, else: t)}
        end
    end

  end

end
