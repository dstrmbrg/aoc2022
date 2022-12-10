defmodule Day06 do

  def part1(input), do: input |> solve(4)
  def part2(input), do: input |> solve(14)

  defp solve(input, marker_length) do
    input
    |> to_charlist()
    |> find_marker(marker_length)
  end

  defp find_marker(list, marker_length) do
    list
    |> Stream.chunk_every(marker_length, 1)
    |> Enum.find_index(&(Enum.uniq(&1) == &1))
    |> Kernel.+(marker_length)
  end
end
