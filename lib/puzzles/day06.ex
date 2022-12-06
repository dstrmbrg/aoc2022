defmodule Day06 do

  def part1(), do: solve(4)
  def part2(), do: solve(14)

  defp solve(marker_length) do
    InputReader.read(6)
    |> to_charlist()
    |> find_marker(marker_length)
    |> IO.puts()
  end

  defp find_marker(list, marker_length) do
    list
    |> Stream.chunk_every(marker_length, 1)
    |> Enum.find_index(&(Enum.uniq(&1) == &1))
    |> Kernel.+(marker_length)
  end
end
