import Config

logger_level =
  case System.get_env("LOG_LEVEL", "info") do
    "debug" -> :debug
    "warn" -> :warn
    _ -> :info
  end

# This configuration determines which log messages, if any, are ignored.
# Eg, at level :warn, messages of level :debug and :info are ignored.
# At level :debug, all messages is logged.
config :logger, level: logger_level
