defmodule Tools do
  def stringify(val), do: to_str(val)

  defp to_str(val) when is_atom(val),    do: ":" <> to_string(val)
  defp to_str(val) when is_integer(val), do: to_string(val)
  defp to_str(val) when is_float(val),   do: to_string(val)
  defp to_str(val) when is_nil(val),     do: "nil"
  defp to_str(val) when is_boolean(val), do: to_string(val)
  defp to_str(val) when is_list(val) do
    buf = to_str_list(val)
    to_string(["[", to_string(buf), "]"])
  end
  defp to_str(val) when is_map(val) do
    keys = Map.keys(val)
    buf = List.foldr(keys, [], fn(key, []) ->
      k = to_str(key)
      v = val |> Map.get(key) |> to_str
      ans = k <> ": " <> v
      [ans]
    (key, acc) ->
      k = to_str(key)
      v = val |> Map.get(key) |> to_str
      ans = k <> ": " <> v
      [ans|["," | acc]]
    end)
    to_string(["%{", to_string(buf), "}"])
  end
  defp to_str(val) when is_tuple(val) do
    buf = val
        |> Tuple.to_list
        |> to_str_list
    to_string(["{", to_string(buf), "}"])
  end
  defp to_str(val) do
    if String.valid?(val), do: to_string(["\"", val, "\""]), else: to_str_bin(val)
  end

  defp to_str_list(list) do
    List.foldr(list, [], fn(it, []) ->
      it_str = to_str(it)
      [it_str];
    (it, accin) ->
        it_str = to_str(it)
      [it_str|["," | accin]]
    end)
  end

  defp to_str_bin(val) when is_binary(val)  do
    to_string(["<<", to_string(val), ">>"])
  end
  defp to_str_bin(_), do: "Tools.to_string() Unknown param"
end
