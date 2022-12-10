defmodule Day10 do
  def part1(input) do
    input
    |> calc_cycles()
    |> Enum.drop(19)
    |> Enum.take_every(40)
    |> Enum.reduce(0, &(&2 + &1.value * &1.cycle))
  end

  def part2(input) do
    input
    |> calc_cycles()
    |> Enum.reduce("", fn %{value: value, cycle: cycle}, acc -> acc <> if abs(value + 1 - rem(cycle, 40)) <= 1, do: "#", else: "." end)
    |> String.graphemes()
    |> Enum.chunk_every(40)
    |> Enum.join("\n")
  end

  defp calc_cycles(input) do
    input
    |> parse()
    |> Enum.reduce(%{cycles: [], next_value: 1}, &(add_instruction(&2, &1)))
    |> Map.get(:cycles)
    |> Enum.with_index(fn value, index -> %{value: value, cycle: index + 1} end)
  end

  defp add_instruction(%{cycles: cycles, next_value: value}, %{cycle_count: cycle_count} = instruction) do
    %{cycles: cycles ++ List.duplicate(value, cycle_count), next_value: next_value(instruction, value)}
  end

  defp next_value(%{instruction_type: :addx, value: val}, current_value), do: current_value + val
  defp next_value(_, current_value), do: current_value

  defp parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row("noop"), do: %{instruction_type: :noop, cycle_count: 1}
  defp parse_row("addx " <> val), do: %{instruction_type: :addx, value: String.to_integer(val), cycle_count: 2}
end
