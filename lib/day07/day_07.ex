defmodule Day07 do
  def part1(input) do
    input
    |> parse()
    |> get_all_sizes()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse()
    |> find_smallest_to_delete()
  end

  defp parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.reduce(%{current_path: [], system: %{size: 0, files: []}}, &(parse_row(&1, &2)))
  end

  defp parse_row("$ cd /", map), do: map |> Map.update!(:current_path, fn _ -> [] end)
  defp parse_row("$ cd ..", map), do: map |> Map.update!(:current_path, &(tl(&1)))
  defp parse_row("$ cd " <> dir, map), do: Map.update!(map, :current_path, &([dir | &1]))
  defp parse_row("$ ls", map), do: map
  defp parse_row("dir " <> dir, map), do: update_in(map, [:system] ++ Enum.reverse(map.current_path), &(Map.put(&1, dir, %{size: 0, files: []})))
  defp parse_row(file, map) do
    [file_size, file_name] = String.split(file) |> then(&([Enum.at(&1, 0) |> String.to_integer(), Enum.at(&1, 1)]))
    path = [:system] ++ Enum.reverse(map.current_path)

    (for i <- Enum.to_list(1..length(path)), do: Enum.take(path, i))
      |> Enum.reduce(map, fn path, acc -> update_in(acc, path ++ [:size], &(&1 + file_size)) end)
      |> update_in(path ++ [:files], &([%{name: file_name, size: file_size} | &1]))
  end

  defp find_smallest_to_delete(%{current_path: _, system: system}) do
    space_needed = (40_000_000 - system.size) |> abs()

    system
    |> get_all_sizes()
    |> Enum.filter(&(&1 >= space_needed))
    |> Enum.sort(fn a, b -> a < b end)
    |> hd()
  end

  defp get_all_sizes(%{current_path: _, system: system}), do: get_all_sizes(system)
  defp get_all_sizes(dir) do
    child_sizes =
      Enum.filter(dir, fn {k, _v} -> !is_atom(k) end)
      |> Enum.map(fn {_k, v} -> v end)
      |> Enum.map(&get_all_sizes/1)
      |> List.flatten()

    [dir.size | child_sizes]
  end
end
