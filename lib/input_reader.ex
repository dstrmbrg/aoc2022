defmodule InputReader do
  def read(day, test) do
    day_string = String.pad_leading(Integer.to_string(day), 2, "0")
    file_name = if test, do: "test", else: "input"

    File.read!("./lib/day#{day_string}/#{file_name}")
  end
end
