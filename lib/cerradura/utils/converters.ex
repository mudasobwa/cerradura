defmodule Cerradura.Utils.Converters do
  @moduledoc """
  Handy utilities to convert different formats.
  """

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
  def latlon({{d1, m1, s1}, {d2, m2, s2}}), do: {latlon({d1, m1, s1}), latlon({d2, m2, s2})}
  def latlon(degminsec) when is_list(degminsec) do
    degminsec
    |> Enum.take(3)
    |> List.to_tuple
    |> latlon
  end
  def latlon({dms1, dms2}) when is_list(dms1) and is_list(dms2), do: {latlon(dms1), latlon(dms2)}

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
  def latlon({dms1, dms2}) when is_float(dms1) and is_float(dms2), do: {latlon(dms1), latlon(dms2)}
  def latlon(degminsec, as_list \\ false) when is_float(degminsec) do
    deg = round(degminsec)
    min = round((degminsec - deg) * 60.0)
    sec = (degminsec - deg - round(min / 60.0)) * 3600.0
    if as_list, do: [deg, min, sec], else: {deg, min, sec}
  end
end
