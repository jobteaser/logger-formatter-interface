# Logger Formatter Interface

This library provides a way to change the output format of the Logger (json, binary, etc.).

Painless k

## Installation

```elixir
def deps do
  [
    {:logger_interface, "~> 1.0.0"}
  ]
end
```

## Usage

```elixir
config :logger, :console
  format: {Logger.Formatter.Interface, :format},
  encoder: Poison # E.g. use Poison and encode your log with the JSON format
```

## FAQ

- Why this library?
> Changing the default formatter of Elixir Logger module is painless. This library simply the Elixir Logger module interface without adding any other dependencies.

- Can we edit the encoder configuration on running application?
> Yes. The encoder is get on the configuration each time the format fonction was call by the Elixir Logger module.

- What's the encoder module's interface?
> The encoder module should only respond to the `encode!/1` function.

## LICENSE

Copyright 2018 JobTeaser

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
