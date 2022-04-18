# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# config :weather_api,
#  ecto_repos: [WeatherApi.Repo]

config :weather_api,
  data_providers: [
    %{
      url: "https://api.aerisapi.com/forecasts/",
      header: [{"Accept", "application/Json"}],
      day: "day",
      format: "json",
      client_id: "BmPlI7N877QdxaMEAHipE",
      client_secret: "e0cIAFR9iUgtdZDPUfwxj7rBlSlVgHyIiaHgJ968",
      limit: 3,
      fields:
        "periods.dateTimeISO,periods.maxTempC,periods.minTempC,periods.maxHumidity,periods.maxFeelslikeC,periods.weather"
    }
  ]

# Configures the endpoint
config :weather_api, WeatherApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: WeatherApiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WeatherApi.PubSub,
  live_view: [signing_salt: "b5fUAWqG"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :weather_api, WeatherApi.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
