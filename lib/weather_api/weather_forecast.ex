defmodule WeatherApi.WeatherForecast do
  require Logger

  @moduledoc """
    Includes methods to get weather forecast by fetching forecast of all given data providers. It consumes a list of data providers from the config file.
  """

  @spec get_weather_forecast(map) :: {:ok, list}
  def get_weather_forecast(%{"city" => city}) do
    IO.puts("Weather Forecast request received from Consumer")
    requestUrl = fetch_url()

      Enum.map(city, fn item -> Task.async(fn -> fetch_city(item, requestUrl) end) end)
      |> Enum.map(fn task -> Task.await(task, 60000) end)
      |> Enum.filter(fn {status, _data} -> status == :ok end)
      |> format_data()

  end

  @spec fetch_url :: %{
          header: any,
          params: %{
            client_id: binary,
            client_secret: binary,
            fields: binary,
            filter: binary,
            format: binary,
            limit: any
          },
          url: any
        }
  def fetch_url() do
    [map] = Application.fetch_env!(:weather_api, :data_providers)

    IO.puts("Weather Forecast request sent to Service Provider")

    clientId = Map.fetch!(map, :client_id)
    clientSecret = Map.fetch!(map, :client_secret)
    day = Map.fetch!(map, :day)
    fields = Map.fetch!(map, :fields)
    format = Map.fetch!(map, :format)
    limit = Map.fetch!(map, :limit)

    header = Map.fetch!(map, :header)
    url = Map.fetch!(map, :url)

    params = %{
      format: "#{format}",
      filter: "#{day}",
      limit: limit,
      fields: "#{fields}",
      client_id: "#{clientId}",
      client_secret: "#{clientSecret}"
    }

    request = %{url: url, header: header, params: params}
    request
  end

  @spec format_data(any) :: list
  def format_data(data) do
    map =
        for x <- data do
          {:ok, map} = x
          map
        end
    IO.puts("Weather Forecast response received from Service Provider")
    IO.puts("Weather Forecast response sent to Consumer")
    IO.inspect map
      {:ok, map}
    end

  @spec parse_response(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            ),
          any
        ) :: {:ok, map} | {:error, :not_found}
  def parse_response(response, city) do
    values =
      response
      |> Poison.decode!()

    if( values["error"] != nil )do
      message = values["error"]
      message = Map.put_new(message, "city", city)
      {:ok, message}
    else
      [data] = values["response"]
      map = Map.put_new(data, "city", city)
      {:ok, map}
    end

  end

  @spec fetch_city(any, map) :: {:error, :failed} | {:ok, map}
  def fetch_city(city, requestUrl) do
    url = Map.fetch!(requestUrl, :url)
    header = Map.fetch!(requestUrl, :header)
    params = Map.fetch!(requestUrl, :params)


    HTTPoison.get!("#{url}#{city}", header, params: params)
    |> case do
      %HTTPoison.Response{status_code: 200, body: body} ->
        parse_response(body, city)

      %HTTPoison.Response{status_code: status_code} ->
        Logger.error("#{city} sends #{status_code} error")
        {:error, :failed}

      _ ->
        Logger.error("Unknown error occured while getting data for #{city}")
        {:error, :failed}
    end
  end
end
