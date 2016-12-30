defmodule Cerradura.Crawler do
  @callback crawl(any, List.t) :: any

  @spec crawl(Atom.t, any, List.t) :: any
  def crawl(type, any, opts \\ []), do: apply(to_module_name(type), :crawl, [any, opts])

  ##############################################################################

  @spec to_module_name(Atom.t, List.t) :: String.t
  defp to_module_name(atom, opts \\ [prefix: Cerradura.Crawlers]) do
    mod = atom
          |> to_string
          |> String.downcase
          |> camelize
    if is_atom(opts[:prefix]), do: Module.concat(opts[:prefix], mod), else: mod
  end

  defp camelize(str) when is_binary(str) do
    Regex.replace(~r/(?:_|\A)(.)/, str, fn _, m -> String.upcase(m) end)
  end
end
