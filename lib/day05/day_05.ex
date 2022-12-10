defmodule Day05 do

  def part1(input), do: input |> solve(true)
  def part2(input), do: input |> solve(false)

  defp solve(input, reverse_move_order) do
    input
    |> parse()
    |> then(fn %{state: state, instructions: instructions} -> Enum.reduce(instructions, state, &(apply_instruction(&2, &1, reverse_move_order))) end)
    |> Enum.reduce("", &(&2 <> hd(&1)))
  end

  defp apply_instruction(state, %{amount: amount, from_index: from_index, to_index: to_index}, reverse_move_order) do
    state
    |> take_crates(amount, from_index, reverse_move_order)
    |> then(fn move ->
      List.update_at(state, to_index, &(move ++ &1))
      |> List.update_at(from_index, &(&1 -- move))
    end)
  end

  defp take_crates(state, amount, from_index, true), do: Enum.take(Enum.at(state, from_index), amount) |> Enum.reverse()
  defp take_crates(state, amount, from_index, false), do: Enum.take(Enum.at(state, from_index), amount)

  defp parse(input) do
    input
    |> String.split(~r/\R{2}/)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [first, second] -> %{state: parse_initial_state(first), instructions: parse_instructions(second)} end)
    |> hd()
  end

  defp parse_initial_state(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.take_while(fn x -> !String.starts_with?(x, " 1") end)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&(Enum.chunk_every(&1, 4) |> Enum.map(fn x -> to_string(x) |> String.replace([" ", "[", "]"], "") end)))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&(Enum.filter(&1, fn x -> x != "" end)))
  end

  defp parse_instructions(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&(Regex.scan(~r/\d+/, &1) |> Enum.map(fn x -> hd(x) end)))
    |> Enum.map(&(Enum.map(&1, fn x -> String.to_integer(x) end)))
    |> Enum.map(&(%{amount: Enum.at(&1, 0), from_index: Enum.at(&1, 1) - 1, to_index: Enum.at(&1, 2) - 1}))
  end
end
