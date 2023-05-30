# WeatherApi

This is a microservice written in Elixir language and is using a third party api's for fetching the weather forecast on the basis of the city,country name as an input.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## API End Point
To access getWeatherForecast api, send post request to http://localhost:4000/api/getWeatherForecast with body:
List of Cities:
{
    "city": [
        "Sydney,au",
        "minneapolis,mn",
        "london,uk"
    ]
} 
Or City:
{
    "city": [
        "Sydney,au"
    ]
}

## Extra Libraries Used
      {:httpoison, "~> 1.8.0"} #to send http request
      {:poison, "~> 3.1"} #to decode JSON value

