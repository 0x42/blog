defmodule Tools do
  def to_str(val) when is_atom(val),    do: ":" <> to_string(val)
  def to_str(val) when is_integer(val), do: to_string(val)
  def to_str(val) when is_float(val),   do: to_string(val)
  def to_str(val) when is_nil(val),     do: "nil"
  def to_str(val) when is_boolean(val), do: to_string(val)
  def to_str(val) when is_list(val) do
    buf = List.foldr(val, [], fn(it, []) ->
      it_str = to_str(it)
      [it_str];
      (it, accin) ->
        it_str = to_str(it)
      [it_str|["," | accin]]
    end)
    to_string(["[", to_string(buf), "]"])
  end
  def to_str(val) do
    if String.valid?(val), do: to_string(["\"", val, "\""]), else: to_str_bin(val)
  end
  
  def to_str_bin(val) when is_binary(val)  do
    to_string(["<<", to_string(val), ">>"])
  end
  def to_str_bin(_), do: "Tools.to_string() Unknown param"
end
