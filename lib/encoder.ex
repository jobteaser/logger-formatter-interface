defmodule Logger.Formatter.Encoder do
  @moduledoc """
  This module provide a simple interface to inject a custom logger formatter.
  """

  # Raise compile error when no logger was configured. This avoid building
  # production application without encoder.
  Application.fetch_env!(:logger, :encoder)

  @doc "Formats a log message as an encoded string."
  @spec format(
          Logger.level(),
          Logger.message(),
          Logger.Formatter.time(),
          keyword()
        ) :: IO.chardata()
  def format(level, message, time, metadata) do
    Map.new(metadata)
    |> Map.merge(%{"msg" => message, "level" => level, "ts" => fmt_dt(time)})
    |> Application.fetch_env!(:logger, :encoder).encode!()
  rescue
    _ ->
      """
      {"msg": "could not format: #{inspect({level, message, time, metadata})}"}
      """
  end

  defp fmt_dt({date, time}) do
    "#{Logger.Formatter.format_date(date)} #{Logger.Formatter.format_time(time)}"
  end
end
