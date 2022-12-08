defmodule Day08 do
  def part1() do
    tensor =
      InputReader.read(8)
      |> parse()

    [
      tensor |> required_height(),
      tensor |> Nx.reverse() |> required_height() |> Nx.reverse(),
      tensor |> Nx.transpose() |> required_height() |> Nx.transpose(),
      tensor |> Nx.transpose() |> Nx.reverse() |> required_height() |> Nx.reverse() |> Nx.transpose()
    ]
    |> Enum.reduce(&(Nx.min(&1, &2)))
    |> then(&(Nx.greater(tensor, &1)))
    |> Nx.sum()
    |> Nx.to_flat_list()
    |> hd()
    |> IO.puts()
  end

  def part2() do
    tensor =
      InputReader.read(8)
      |> parse()

    {height, width} = tensor.shape()

    (for x <- Enum.to_list(1..width - 2), y <- Enum.to_list(1..height - 2), do:
      scenic_score(tensor, x, y))
      |> Enum.max()
      |> IO.puts()
  end

  defp parse(input) do
    input
    |> String.split("\r\n")
    |> Enum.reduce([], fn row, acc -> acc ++ [row |> String.graphemes() |> Enum.map(&String.to_integer/1)] end)
    |> Nx.tensor()
  end

  defp scenic_score(tensor, x, y) do
    this_height = tensor[y][x] |> Nx.to_flat_list() |> hd()

    {height, width} = tensor.shape()

    [
      tensor |> Nx.slice([0, x], [y, 1]) |> Nx.to_flat_list() |> Enum.reverse(),
      tensor |> Nx.slice([y, 0], [1, x]) |> Nx.to_flat_list() |> Enum.reverse(),
      tensor |> Nx.slice([y, x + 2], [1, width - x - 1]) |> Nx.to_flat_list(),
      tensor |> Nx.slice([y + 2, x], [height - y - 1, 1]) |> Nx.to_flat_list(),
    ]
    |> Enum.map(fn x -> x |> take_until_gte(this_height) |> length() end)
    |> Enum.product()
  end

  defp required_height(tensor) do
    {height, width} = tensor.shape()

    tensor
    |> Nx.cumulative_max(axis: 1)
    |> Nx.slice([0, 0], [height, width - 1])
    |> Nx.pad(-1, [{0, 0, 0}, {1, 0, 0}])
  end

  defp take_until_gte([], _val), do: []
  defp take_until_gte([h | _t], val) when h >= val, do: [h]
  defp take_until_gte([h | t], val), do: [h | take_until_gte(t, val)]
end
