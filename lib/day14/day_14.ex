defmodule Day14 do
  def part1(input) do
    obstacles =
      input
      |> parse()

    y_max = Enum.max_by(obstacles, fn {_, y} -> y end) |> elem(1)
    solve(obstacles, y_max, false, 0)
  end

  def part2(input) do
    obstacles =
      input
      |> parse()

    y_max = Enum.max_by(obstacles, fn {_, y} -> y end) |> elem(1)
    solve(obstacles, y_max + 2, true, 0)
  end

  defp solve(obstacles, y_max, max_is_floor, level) do
    case simulate_sand(obstacles, {500, 0}, y_max, max_is_floor) do
      {500, 0} -> level + 1
      nil -> level
      sand_pos -> solve(MapSet.put(obstacles, sand_pos), y_max, max_is_floor, level + 1)
    end
  end

  defp simulate_sand(_obstacles, {_x, y}, y_max, false) when y == y_max, do: nil
  defp simulate_sand(_obstacles, {x, y}, y_max, true) when y + 1 == y_max, do: {x, y}
  defp simulate_sand(obstacles, {x, y}, y_max, max_is_floor) do
    case move(x, y, obstacles) do
      nil -> {x, y}
      pos -> simulate_sand(obstacles, pos, y_max, max_is_floor)
    end
  end

  defp move(x, y, obstacles) do
    [
      {x, y + 1},
      {x - 1, y + 1},
      {x + 1, y + 1}
    ]
    |> Enum.find(&!MapSet.member?(obstacles, &1))
  end

  defp parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&(Regex.scan(~r/\d+/, &1) |> Enum.map(fn x -> x |> hd() |> String.to_integer() end)))
    |> Enum.map(&(Enum.chunk_every(&1, 4, 2, :discard) |> Enum.map(fn [x1, y1, x2, y2] -> coords_in_path(x1, y1, x2, y2) end)))
    |> List.flatten()
    |> MapSet.new()
  end

  defp coords_in_path(x1, y1, x2, y2) when x1 == x2, do: y1..y2 |> Enum.map(&({x1, &1}))
  defp coords_in_path(x1, y1, x2, y2) when y1 == y2, do: x1..x2 |> Enum.map(&({&1, y1}))
end
