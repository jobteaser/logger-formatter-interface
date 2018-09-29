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
    |> Map.merge(%{"msg" => clean_message(message), "level" => level, "ts" => fmt_dt(time)})
    |> Application.fetch_env!(:logger, :encoder).encode!()
  rescue
    error ->
      """
      {"msg": "could not format: #{inspect({level, message, time, metadata})}", "error": #{
        inspect({error})
      }"}
      """
  end

  defp clean_message(message) when is_list(message) do
    message
    |> List.flatten()
    |> Enum.filter(&is_binary/1)
    |> Enum.reduce("", fn x, acc -> "#{acc} #{x}" end)
    |> String.trim()
  end

  defp clean_message(message), do: message

  defp fmt_dt({date, time}) do
    "#{Logger.Formatter.format_date(date)} #{Logger.Formatter.format_time(time)}"
  end
end
