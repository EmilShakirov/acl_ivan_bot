use Mix.Config

config :alice,
  api_key: System.get_env("SLACK_KEY"),
  room: "#random",
  state_backend: :redis,
  redis: "redis://127.0.0.1:6379"

config :logger,
  level: :info,
  truncate: 32_768
