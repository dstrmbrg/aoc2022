defmodule Day13 do
  def part1(input) do
    input
    |> parse()
    |> Enum.chunk_every(2)
    |> Enum.with_index(1)
    |> Enum.filter(fn {[first, second], _} -> in_order(first, second) |> elem(1) end)
    |> Enum.reduce(0, fn {_, index}, acc -> acc + index end)
  end

  def part2(input) do
    divider_packets = [[[2]], [[6]]]

    input
    |> parse()
    |> Kernel.++(divider_packets)
    |> Enum.sort(&in_order(&1, &2) |> elem(1))
    |> Enum.with_index(1)
    |> Enum.filter(&Enum.member?(divider_packets, elem(&1, 0)))
    |> Enum.reduce(1, fn {_, index}, acc -> acc * index end)
  end

  defp in_order([], []), do: {:not_evaluated, nil}
  defp in_order([], [_ | _]), do: {:ok, true}
  defp in_order([_ | _], []), do: {:ok, false}
  defp in_order([h1 | t1], [h2 | t2]) when is_integer(h1) and is_integer(h2) and h1 == h2, do: in_order(t1, t2)
  defp in_order([h1 | _], [h2 | _]) when is_integer(h1) and is_integer(h2), do: {:ok, h1 < h2}
  defp in_order([h1 | t1], second) when is_integer(h1), do: in_order([[h1] | t1], second)
  defp in_order(first, [h2 | t2]) when is_integer(h2), do: in_order(first, [[h2] | t2])
  defp in_order([h1 | t1], [h2 | t2]) do
    case in_order(h1, h2) do
      {:ok, result} -> {:ok, result}
      _ -> in_order(t1, t2)
    end
  end

  defp parse(input) do
    input
    |> String.split(~r/\R+/)
    |> Enum.map(&(Code.eval_string(&1) |> elem(0)))
  end
end
