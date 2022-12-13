defmodule Day12 do
  def part1(input) do
    %{height_map: height_map, start: start, goal: goal} =
      input
      |> parse()

      bfs(height_map, [%{current: start, path: [start], elevation: 1}], [], :reach_goal, goal)
  end

  def part2(input) do
    %{height_map: height_map, goal: start} =
      input
      |> parse()

      bfs(height_map, [%{current: start, path: [start], elevation: 26}], [], :find_lowest_elevation)
  end

  defp bfs(height_map, queue, visited, mode, goal \\ {0, 0})
  defp bfs(_height_map, [%{current: current, path: path} | _queue], _visited, :reach_goal, goal) when current == goal, do: length(path) - 1
  defp bfs(_height_map, [%{elevation: elevation, path: path} | _queue], _visited, :find_lowest_elevation, _goal) when elevation == 1, do: length(path) - 1
  defp bfs(height_map, [%{current: current, path: path, elevation: elevation} | queue], visited, mode, goal) do
    valid_moves = valid_moves(current, height_map, visited, elevation, mode)
    enqueue = valid_moves |> Enum.map(& %{current: &1, path: [&1 | path], elevation: Map.get(height_map, &1)})

    bfs(height_map, queue ++ enqueue, visited ++ valid_moves, mode, goal)
  end

  defp valid_moves(current, height_map, visited, elevation, mode) do
    fun = elevation_limitation_fun(mode)

    current
    |> adjacent_coordinates()
    |> Enum.filter(fn adjacent ->
      adjacent_elevation = Map.get(height_map, adjacent)
      already_visited = Enum.find(visited, &(&1 == adjacent)) != nil

      !already_visited and adjacent_elevation != nil and fun.(elevation, adjacent_elevation)
    end)
  end

  defp elevation_limitation_fun(:reach_goal), do: fn current, adjacent -> adjacent - current <= 1 end
  defp elevation_limitation_fun(:find_lowest_elevation), do: fn current, adjacent -> current - adjacent <= 1 end

  defp adjacent_coordinates({x, y}), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

  defp parse(input) do
    full_map =
      input
      |> String.split(~r/\R/)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, y_index}, acc -> Map.merge(acc, parse_row(row, y_index)) end)

    height_map = full_map |> Enum.reduce(%{}, fn {key, val}, acc -> Map.put(acc, key, val.elevation) end)
    start = full_map |> Enum.find(fn {_, val} -> val.is_start end) |> elem(0)
    goal = full_map |> Enum.find(fn {_, val} -> val.is_goal end) |> elem(0)

    %{height_map: height_map, start: start, goal: goal}
  end

  defp parse_row(row, y_index) do
    row
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {val, x_index}, acc -> Map.put(acc, {x_index, -1 * y_index}, %{elevation: parse_elevation(val), is_start: val == ?S, is_goal: val == ?E}) end)
  end

  defp parse_elevation(?S), do: 1
  defp parse_elevation(?E), do: ?z - ?a + 1
  defp parse_elevation(code_point), do: code_point - ?a + 1
end
