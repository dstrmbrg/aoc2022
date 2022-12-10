defmodule Day10 do
  def part1() do
    calc_cycles()
    |> Enum.drop(19)
    |> Enum.take_every(40)
    |> Enum.reduce(0, &(&2 + &1.value * &1.cycle))
    |> IO.puts()
  end

  def part2() do
    calc_cycles()
    |> Enum.reduce("", fn %{value: value, cycle: cycle}, acc -> acc <> if abs(value + 1 - rem(cycle, 40)) <= 1, do: "#", else: "." end)
    |> String.graphemes()
    |> Enum.chunk_every(40)
    |> Enum.join("\r\n")
    |> IO.puts()
  end

  defp calc_cycles() do
    InputReader.read(10)
    |> parse()
    |> Enum.reduce(%{cycles: [], next_value: 1}, &(add_instruction(&2, &1)))
    |> Map.get(:cycles)
    |> Enum.with_index(fn value, index -> %{value: value, cycle: index + 1} end)
  end

  defp add_instruction(%{cycles: cycles, next_value: value}, %{instruction: _, repeat: _} = instruction) do
    %{cycles: cycles ++ List.duplicate(value, instruction.repeat), next_value: get_next_value(instruction, value)}
  end

  defp get_next_value(%{instruction: :noop}, current_value), do: current_value
  defp get_next_value(%{instruction: :addx, value: val}, current_value), do: current_value + val

  defp parse(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&parse_row/1)
  end

  defp parse_row("noop"), do: %{instruction: :noop, repeat: 1}
  defp parse_row("addx " <> val), do: %{instruction: :addx, value: String.to_integer(val), repeat: 2}
end
