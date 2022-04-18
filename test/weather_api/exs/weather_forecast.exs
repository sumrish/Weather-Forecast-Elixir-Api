defmodule WeatherApiWeb.WeatherForecastTest do
  use WeatherApiWeb.ConnCase
  alias WeatherApi.WeatherForecast

  @invalid_attrs %{"city": ["sydney" , "minneapolis" , "london"]}
  @valid_attrs %{"city": ["sydney,au" , "minneapolis,mn" , "london,uk"]}

  describe "weather forecast" do
    test "weather forecast with valid attributes" do
      {:ok, weather_forecast} = WeatherForecast.get_weather_forecast(@valid_attrs)
      assert weather_forecast != nil
      assert Map.get(weather_forecast, :weather_forecast) != nil
    end

    test "weather forecast with city without state" do
      assert WeatherForecast.get_weather_forecast(@invalid_attrs) == {:error, :not_found}
    end
  end
end
