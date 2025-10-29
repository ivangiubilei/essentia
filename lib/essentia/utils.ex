defmodule Essentia.Utils do
  defmodule For do
    def replace_for(list) do
      list
      |> group_blocks()
      |> repeat_x_times()
      |> List.flatten()
      |> Enum.reverse()
    end

    def group_blocks(list), do: do_group(list, [])

    defp do_group([], acc), do: Enum.reverse(acc)

    defp do_group(["end" | rest], acc) do
      {block, tail} = collect_inner(rest, [])
      do_group(tail, [block | acc])
    end

    defp do_group([x | rest], acc), do: do_group(rest, [x | acc])

    defp collect_inner(["end" | rest], acc) do
      {inner, tail} = collect_inner(rest, [])
      collect_inner(tail, [inner | acc])
    end

    defp collect_inner(["for" | rest], acc), do: {acc, rest}
    defp collect_inner([x | rest], acc), do: collect_inner(rest, [x | acc])

    def repeat_x_times(list), do: _repeat_x_times(list, [])
    defp _repeat_x_times([], acc), do: acc

    defp _repeat_x_times([h | t], acc) when is_list(h) do
      IO.inspect(h)

      count =
        h
        |> List.first()
        |> String.to_integer()

      h = List.delete_at(h, 0)

      repeated =
        List.duplicate(h, count)
        |> List.flatten()

      _repeat_x_times(t, [repeated | acc])
    end

    defp _repeat_x_times([h | t], acc) do
      _repeat_x_times(t, [h | acc])
    end
  end
end
