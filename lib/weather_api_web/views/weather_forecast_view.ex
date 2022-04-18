defmodule WeatherApiWeb.WeatherForecastView do
  use WeatherApiWeb, :view
  alias WeatherApiWeb.WeatherForecastView

  def render("index.json", %{weather_forecast: list}) do
    %{data: render_many(list, WeatherForecastView, "weather_forecast.json")}
  end

  def render("show.json", %{weather_forecast: periods}) do
    %{data: render_one(periods, WeatherForecastView, "weather_forecast.json")}
  end

  def render("weather_forecast.json", %{weather_forecast: periods}) do
    %{
      weather_forecast: periods
    }
  end
end
