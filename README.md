# Logger Formatter Encoder

This library provide a simple way to change the formatter of the Logger console
backend.

## Installation

```elixir
def deps do
  [
    {:logger_encoder, "~> 0.1.0"}
  ]
end
```

## How to use

```
config :logger,
  encoder: Poison # to use Poison and encode your log with the JSON format
```
