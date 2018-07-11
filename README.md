# Logger Formatter Interface

This library provides a way to change the output format of the Logger (json, xml, etc.).

## Installation

```elixir
def deps do
  [
    {:logger_interface, "~> 0.1.0"}
  ]
end
```

## How to use

```
config :logger, :console
  format: {Logger.Formatter.Interface, :format},
  encoder: Poison # to use Poison and encode your log with the JSON format
```
