defmodule Cerradura.Utils.Converters do

  @round_to 7

  @doc """
  Converts tuple `{deg, min, sec}` to `float`

  ## Examples

      iex> Cerradura.Utils.Converters.latlon([41, 22, 9])
      41.3691667
      iex> Cerradura.Utils.Converters.latlon({2, 10, 20})
      2.1722222
  """
  def latlon({deg, min, sec}), do: Float.round(deg + min / 60.0 + sec / 3600.0, @round_to)
  def latlon(degminsec) when is_list(degminsec) do
    degminsec
    |> Enum.take(3)
    |> List.to_tuple
    |> latlon
  end

  @doc """
  Converts `float` latlon to tuple `{deg, min, sec}`

  ## Examples

      iex> {deg, min, _} = Cerradura.Utils.Converters.latlon(41.3691667)
      ...> [deg, min]
      [41, 22]
      iex> [deg, min, _] = Cerradura.Utils.Converters.latlon(2.1722222, true)
      ...> [deg, min]
      [2, 10]
  """
  def latlon(degminsec, as_list \\ false) when is_float(degminsec) do
    deg = round(degminsec)
    min = round((degminsec - deg) * 60.0)
    sec = (degminsec - deg - round(min / 60.0)) * 3600.0
    if as_list, do: [deg, min, sec], else: {deg, min, sec}
  end
end
