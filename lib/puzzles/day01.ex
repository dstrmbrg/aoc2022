defmodule Day01 do

  def part1() do
    InputReader.read(1)
    |> parse()
    |> Enum.map(&(Enum.sum(&1)))
    |> Enum.max()
    |> IO.puts()
  end

  def part2() do
    InputReader.read(1)
    |> parse()
    |> Enum.map(&(Enum.sum(&1)))
    |> Enum.sort(&(&1 > &2))
    |> Enum.take(3)
    |> Enum.sum()
    |> IO.puts()
  end

  defp parse(input) do
    input
    |> String.split("\r\n\r\n")
    |> Enum.map(&(String.split(&1, "\r\n")))
    |> Enum.map(&(list_to_integer(&1)))
  end

  defp list_to_integer(string_list), do: Enum.map(string_list, &(String.to_integer(&1)))
end
