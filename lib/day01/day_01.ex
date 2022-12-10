defmodule Day01 do

  def part1(input) do
    input
    |> parse()
    |> Enum.map(&(Enum.sum(&1)))
    |> Enum.max()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(&(Enum.sum(&1)))
    |> Enum.sort(&(&1 > &2))
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.split(~r/\R{2}/)
    |> Enum.map(&(String.split(&1, ~r/\R/)))
    |> Enum.map(&(list_to_integer(&1)))
  end

  defp list_to_integer(string_list), do: Enum.map(string_list, &(String.to_integer(&1)))
end
