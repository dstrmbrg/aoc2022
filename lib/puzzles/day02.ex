defmodule Day02 do

  @win_score 6
  @draw_score 3
  @loss_score 0

  @moves %{
    rock: %{
      beats: :scissors,
      score: 1
    },
    paper: %{
      beats: :rock,
      score: 2
    },
    scissors: %{
      beats: :paper,
      score: 3
    }
  }

  def part1() do
    InputReader.read(2)
    |> parse_strategy_one()
    |> Enum.map(&(calc_score(&1)))
    |> Enum.sum()
    |> IO.puts()
  end

  def part2() do
    InputReader.read(2)
    |> parse_strategy_two()
    |> Enum.map(&(calc_score_two(&1)))
    |> Enum.sum()
    |> IO.puts()
  end

  defp calc_score(round), do: round_outcome_score(round) + @moves[round[:response]][:score]

  defp calc_score_two(round) do
    move = get_move(round)
    round_outcome_score_two(round[:outcome]) + @moves[move][:score]
  end

  defp round_outcome_score(%{opponent: o, response: r }) when o == r, do: @draw_score
  defp round_outcome_score(%{opponent: o, response: r}), do: if @moves[r][:beats] == o, do: @win_score, else: @loss_score

  defp round_outcome_score_two(:lose), do: @loss_score
  defp round_outcome_score_two(:draw), do: @draw_score
  defp round_outcome_score_two(:win), do: @win_score

  def get_move(round) do
    case round.outcome do
      :lose -> @moves[round.opponent][:beats]
      :draw -> round.opponent
      :win -> get_winning_move(round.opponent)
    end
  end

  defp get_winning_move(opponent), do: Enum.find(@moves, fn {_key, val} -> val[:beats] == opponent end) |> elem(0)

  defp parse_strategy_one(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&(String.split(&1, " ") |> then(fn [first, second] -> %{opponent: parse_play(first), response: parse_play(second)} end)))
  end

  defp parse_strategy_two(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&(String.split(&1, " ") |> then(fn [first, second] -> %{opponent: parse_play(first), outcome: parse_round_outcome(second)} end)))
  end

  defp parse_play(p) when p == "A" or p == "X", do: :rock
  defp parse_play(p) when p == "B" or p == "Y", do: :paper
  defp parse_play(p) when p == "C" or p == "Z", do: :scissors

  defp parse_round_outcome("X"), do: :lose
  defp parse_round_outcome("Y"), do: :draw
  defp parse_round_outcome("Z"), do: :win
end
