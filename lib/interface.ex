defmodule Logger.Formatter.Interface do
  @moduledoc """
  This module provide a simple interface to inject a custom logger formatter.
  """

  @callback encode!(map()) :: IO.chardata()

  @doc "Formats a log message as an encoded string."
  @spec format(
          Logger.level(),
          Logger.message(),
          Logger.Formatter.time(),
          keyword()
        ) :: IO.chardata()
  def format(level, message, time, metadata) do
    Map.new(metadata)
    |> Map.merge(%{
      "message" => :erlang.iolist_to_binary(message),
      "level" => level,
      "ts" => fmt_dt(time)
    })
    |> Application.fetch_env!(:logger, :encoder).encode!()
  rescue
    error ->
      """
      {"message": "could not format: #{inspect({level, message, time, metadata})}", "error": #{
        inspect({error})
      }"}
      """
  end

  defp fmt_dt({date, time}) do
    "#{Logger.Formatter.format_date(date)} #{Logger.Formatter.format_time(time)}"
  end
end
