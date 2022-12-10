defmodule Day09 do
  def part1(input), do: input |> solve(2)
  def part2(input), do: input |> solve(10)

  defp solve(input, rope_length) do
    rope = List.duplicate(%{x: 0, y: 0}, rope_length)

    input
    |> parse()
    |> Enum.reduce(%{rope: rope, tail_path: []}, &(next_state(&2, &1)))
    |> Map.get(:tail_path)
    |> Enum.uniq()
    |> length()
  end

  defp next_state(state, %{direction: direction, steps: steps}) do
    1..steps
    |> Enum.reduce(state, fn _, state -> next_state(state, direction) end)
  end

  defp next_state(state, direction) do
    rope =
      state.rope
      |> move_head(direction)
      |> move_tail()

    %{rope: rope, tail_path: [List.last(rope) | state.tail_path]}
  end

  defp move_head([head | tail], direction), do: [get_head(head, direction) | tail]

  defp get_head(head, "U"), do: %{x: head.x, y: head.y + 1}
  defp get_head(head, "D"), do: %{x: head.x, y: head.y - 1}
  defp get_head(head, "L"), do: %{x: head.x - 1, y: head.y}
  defp get_head(head, "R"), do: %{x: head.x + 1, y: head.y}

  defp move_tail([elem]), do: [elem]
  defp move_tail([first | [second | rest]]), do: [first | move_tail([get_tail_pos(first, second) | rest])]

  defp get_tail_pos(first, second) when abs(first.x - second.x) <= 1 and abs(first.y - second.y) <= 1, do: second
  defp get_tail_pos(first, second) do
    delta_x = first.x - second.x
    delta_y = first.y - second.y
    step_x = if delta_x != 0, do: div(abs(delta_x), delta_x), else: 0
    step_y = if delta_y != 0, do: div(abs(delta_y), delta_y), else: 0

    %{x: second.x + step_x, y: second.y + step_y}
  end

  defp parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line -> String.split(line) |> then(&(%{direction: Enum.at(&1, 0), steps: Enum.at(&1, 1) |> String.to_integer()})) end)
  end
end
