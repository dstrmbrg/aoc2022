defmodule Day04 do

  def part1(input), do: input |> solve(fn [first, second, combined] -> first == combined or second == combined end)
  def part2(input), do: input |> solve(fn [first, second, combined] -> length(first) + length(second) != length(combined) end)

  defp solve(input, countfn) do
    input
    |> parse()
    |> Enum.map(fn [first, second] -> [first, second, first ++ second |> Enum.uniq() |> Enum.sort()] end)
    |> Enum.count(countfn)
  end

  defp parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&(Regex.scan(~r/\d+/, &1) |> Enum.map(fn x -> hd(x) end)))
    |> Enum.map(&(Enum.map(&1, fn x -> String.to_integer(x) end)))
    |> Enum.map(&([Enum.to_list(Enum.at(&1, 0)..Enum.at(&1, 1)), Enum.to_list(Enum.at(&1, 2)..Enum.at(&1, 3))]))
  end
end
