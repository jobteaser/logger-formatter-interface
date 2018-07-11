defmodule Logger.Formatter.JSON do
  @moduledoc """
  Documentation for Logger.Formatter.JSON.
   + add application env in logger config
   + compile time error without configuration
  """

  # Raise compile error when no logger was configured. This avoid building
  # production application without JSON encoder.
  # TODO: fail condition only in use
  Application.fetch_env!(:logger, :json_encoder)

  @doc "Formats a log message as a JSON encoded string."
  @spec format(
          Logger.level(),
          Logger.message(),
          Logger.Formatter.time(),
          keyword()
        ) :: IO.chardata()
  # Avoid fail in the formatting function.
  def format(level, message, time, metadata) do
    # This order avoid metadata overiding the default fields.
    Map.new(metadata)
    |> Map.merge(%{"msg" => message, "level" => level, "ts" => fmt_dt(time)})
    |> Application.fetch_env!(:logger, :json_encoder).encode!()
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
