defmodule WeatherApiWeb.WeatherForecastController do
  use WeatherApiWeb, :controller
  alias WeatherApi.WeatherForecast
  action_fallback(WeatherApiWeb.FallbackController)

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"city" => city}) do
    WeatherForecast.get_weather_forecast(%{"city" => city})
    |> case do
      {:ok, weather_forecast} ->
        render(conn, "show.json", weather_forecast: weather_forecast)

      {:error, message} ->
        json(conn, %{ error: %{details: message}})
    end
  end

  def show(conn, _) do
    json(conn,%{ error: %{details: "invalid parameters" }})
  end
end
