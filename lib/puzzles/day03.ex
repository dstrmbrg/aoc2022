defmodule Day03 do
  def part1() do
    InputReader.read(3)
    |> parse()
    |> Enum.map(&(Enum.chunk_every(&1, div(length(&1), 2))))
    |> Enum.map(fn [first, second] -> MapSet.intersection(MapSet.new(first), MapSet.new(second)) |> MapSet.to_list() end)
    |> Enum.map(&(get_priority(&1)))
    |> Enum.sum()
    |> IO.puts()
  end

  def part2() do
    InputReader.read(3)
    |> parse()
    |> Enum.chunk_every(3)
    |> Enum.map(fn [first, second, third] ->
      MapSet.intersection(MapSet.new(first), MapSet.new(second))
      |> MapSet.intersection(MapSet.new(third))
      |> MapSet.to_list() end)
    |> Enum.map(&(get_priority(&1)))
    |> Enum.sum()
    |> IO.puts()
  end

  defp parse(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&(String.to_charlist(&1)))
  end

  defp get_priority([item | _]) when item >= ?a and item <= ?z, do: item - ?a + 1
  defp get_priority([item | _]) when item >= ?A and item <= ?Z, do: item - ?A + 27
end
