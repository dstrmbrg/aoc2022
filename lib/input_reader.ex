defmodule InputReader do
  def read(day) do
    day_string = String.pad_leading(Integer.to_string(day), 2, "0")
    File.read!("./lib/inputs/day#{day_string}.txt")
  end
end
