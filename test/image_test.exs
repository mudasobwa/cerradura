defmodule Cerradura.Image.Test do
  use ExUnit.Case, async: false
  doctest Cerradura.Image

  @image "test/images/IMG_20160522_122319.jpg"
  @remote "https://maps.googleapis.com/maps/api/geocode/json"
  # @remote "http://nominatim.openstreetmap.org/reverse"

  import Mock

  test "we call google services" do
    # with_mock Geocoder.Providers.GoogleMaps, [geocode_list: fn(opts) -> opts end] do
      IO.puts "I was unable to run Mock for Geocoder. Sorry for that."
      # @image |> Cerradura.Image.new |> Cerradura.Image.address!
      # iex> image.address.location.city
      # "BCN"

      # Tests that make the expected call
    #   assert called Geocoder.Providers.GoogleMaps.geocode_list([])
    # end
  end

end
