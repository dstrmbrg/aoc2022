defmodule Day11 do
  def part1(input), do: input |> parse() |> solve(20, &(div(&1, 3)))
  def part2(input) do
    monkeys = parse(input)
    common_multiple =
      monkeys
      |> Enum.map(&(Map.get(&1, :divisor)))
      |> Enum.product()

    solve(monkeys, 10_000, &(rem(&1, common_multiple)))
  end

  defp solve(monkeys, limit, limit_worry_levels_fun) do
    monkeys
    |> simulate_monkeys(0, limit, limit_worry_levels_fun)
    |> Enum.map(&(Map.get(&1, :inspects)))
    |> Enum.sort(&(&1 > &2))
    |> Enum.take(2)
    |> Enum.product()
  end

  defp simulate_monkeys(monkeys, level, limit, _) when level == limit, do: monkeys
  defp simulate_monkeys(monkeys, level, limit, limit_worry_levels_fun) do
    0..length(monkeys) - 1
    |> Enum.reduce(monkeys, &(monkey_do_round(&2, &1, limit_worry_levels_fun)))
    |> simulate_monkeys(level + 1, limit, limit_worry_levels_fun)
  end

  defp monkey_do_round(monkeys, monkey_index, limit_worry_levels_fun) do
    monkeys
    |> Enum.at(monkey_index)
    |> Map.get(:items)
    |> Enum.reduce(monkeys, &(monkey_do_item(&2, &1, monkey_index, limit_worry_levels_fun)))
    |> List.update_at(monkey_index, &(Map.update!(&1, :items, fn _ -> [] end)))
  end

  defp monkey_do_item(monkeys, item, monkey_index, limit_worry_levels_fun) do
    monkey = Enum.at(monkeys, monkey_index)
    new_item = monkey.change_fun.(item) |> limit_worry_levels_fun.()
    throw_to_index = if rem(new_item, monkey.divisor) == 0, do: monkey.throw_if_true, else: monkey.throw_if_false

    monkeys
    |> List.update_at(monkey_index, &(Map.update!(&1, :inspects, fn n -> n + 1 end)))
    |> List.update_at(throw_to_index, &(Map.update!(&1, :items, fn items -> items ++ [new_item] end)))
  end

  defp parse(input) do
    input
    |> String.split(~r/\R{2}/)
    |> Enum.reduce([], &(&2 ++ [parse_monkey(&1)]))
  end

  defp parse_monkey(monkey_string) do
    monkey_string
    |> String.split(~r/\R/)
    |> Enum.reduce(%{inspects: 0}, &(parse_row_and_update_monkey(&2, String.trim(&1))))
  end

  defp parse_row_and_update_monkey(monkey, "Starting items: " <> items), do: Map.put(monkey, :items, "[#{items}]" |> Code.eval_string() |> elem(0))
  defp parse_row_and_update_monkey(monkey, "Operation: new = old * old"), do: Map.put(monkey, :change_fun, &(&1 * &1))
  defp parse_row_and_update_monkey(monkey, "Operation: new = old * " <> factor), do: Map.put(monkey, :change_fun, &(&1 * String.to_integer(factor)))
  defp parse_row_and_update_monkey(monkey, "Operation: new = old + " <> term), do: Map.put(monkey, :change_fun, &(&1 + String.to_integer(term)))
  defp parse_row_and_update_monkey(monkey, "Test: divisible by " <> divisor), do: Map.put(monkey, :divisor, String.to_integer(divisor))
  defp parse_row_and_update_monkey(monkey, "If true: throw to monkey " <> monkey_index), do: Map.put(monkey, :throw_if_true, String.to_integer(monkey_index))
  defp parse_row_and_update_monkey(monkey, "If false: throw to monkey " <> monkey_index), do: Map.put(monkey, :throw_if_false, String.to_integer(monkey_index))
  defp parse_row_and_update_monkey(monkey, _), do: monkey
end
