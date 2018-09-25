defmodule Logger.Formatter.Encoder.MixProject do
  use Mix.Project

  def project do
    [
      app: :logger_interface,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      name: "Logger.Formatter.Encoder",
      description: "A simple logger interface for Elixir console backend",
      source_url: "https://github.com/jobteaser/logger-formatter-interface",
      homepage_url: "http://github.com/jobteaser/logger-formatter-interface",
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    []
  end

  defp package do
    [
      name: "logger_interface",
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jobteaser/logger-formatter-interface"},
      maintainers: ["Gearnode <friminb@gmail.com>", "Yann Very <yann.very@joteaser.com>"]
    ]
  end
end
