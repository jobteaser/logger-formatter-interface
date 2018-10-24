defmodule DummyEncoderSuccess do
  def encode!(_), do: ""
end

defmodule DummyEncoderFail do
  def encode!(_), do: raise("foo")
end

defmodule EncoderExpecter do
  def encode!(map) do
    if map["ts"] != "2014-12-30 12:06:30.100", do: raise("ts not ok")

    if map["message"] != "hello world", do: raise("message not ok")
    if map["level"] != :error, do: raise("level not ok")
    if map[:foo] == nil, do: raise("foo not ok")
    ""
  end
end

defmodule PipeEncoder do
  def encode!(map), do: map["message"]
end

defmodule Logger.Formatter.InterfaceTest do
  use ExUnit.Case

  alias Logger.Formatter.Interface

  test "log record without metadata" do
    Application.put_env(:logger, :encoder, DummyEncoderSuccess)

    assert Interface.format(nil, nil, nil, nil) ==
             "{\"message\": \"could not format: {nil, nil, nil, nil}\", \"error\": {%Protocol.UndefinedError{description: \"\", protocol: Enumerable, value: nil}}\"}\n"

    assert Interface.format(:error, nil, nil, nil) ==
             "{\"message\": \"could not format: {:error, nil, nil, nil}\", \"error\": {%Protocol.UndefinedError{description: \"\", protocol: Enumerable, value: nil}}\"}\n"

    assert Interface.format(:error, "hello world", nil, nil) ==
             "{\"message\": \"could not format: {:error, \"hello world\", nil, nil}\", \"error\": {%Protocol.UndefinedError{description: \"\", protocol: Enumerable, value: nil}}\"}\n"

    assert Interface.format(:error, "hello world", {{2014, 12, 30}, {12, 6, 30, 100}}, nil) ==
             "{\"message\": \"could not format: {:error, \"hello world\", {{2014, 12, 30}, {12, 6, 30, 100}}, nil}\", \"error\": {%Protocol.UndefinedError{description: \"\", protocol: Enumerable, value: nil}}\"}\n"
  end

  test "log record with all requirements" do
    Application.put_env(:logger, :encoder, DummyEncoderSuccess)
    assert Interface.format(:error, "hello world", {{2014, 12, 30}, {12, 6, 30, 100}}, []) == ""

    assert Interface.format(:error, "hello world", {{2014, 12, 30}, {12, 6, 30, 100}}, foo: "bar") ==
             ""
  end

  test "log record with a invalid encoder" do
    Application.put_env(:logger, :encoder, DummyEncoderFail)

    assert Interface.format(:error, "hello world", {{2014, 12, 30}, {12, 6, 30, 100}}, foo: "bar") ==
             "{\"message\": \"could not format: {:error, \"hello world\", {{2014, 12, 30}, {12, 6, 30, 100}}, [foo: \"bar\"]}\", \"error\": {%RuntimeError{message: \"foo\"}}\"}\n"
  end

  test "formatter output" do
    Application.put_env(:logger, :encoder, EncoderExpecter)

    assert Interface.format(:error, "hello world", {{2014, 12, 30}, {12, 6, 30, 100}}, foo: "bar") ==
             ""

    assert Interface.format(
             :error,
             "hello world",
             {{2014, 12, 30}, {12, 6, 30, 100}},
             foo: "bar",
             ts: "foobar"
           ) == ""

    assert Interface.format(
             :error,
             ["hello", 32, ["world"]],
             {{2014, 12, 30}, {12, 6, 30, 100}},
             foo: "bar"
           ) == ""
  end

  test "message cleanup with a list" do
    Application.put_env(:logger, :encoder, PipeEncoder)

    assert Interface.format(
             :error,
             [
               "QUERY",
               32,
               "OK",
               "",
               [32, "db", 61, '1.8', 109, 115],
               [],
               [32, "queue", 61, '94.1', 109, 115],
               10,
               "SELECT relname FROM pg_class WHERE relname = 'keys'",
               32,
               "[]"
             ],
             {{2014, 12, 30}, {12, 6, 30, 100}},
             foo: "bar"
           ) ==
             "QUERY OK db=1.8ms queue=94.1ms\nSELECT relname FROM pg_class WHERE relname = 'keys' []"
  end

  test "message cleanup with an improperlist" do
    Application.put_env(:logger, :encoder, PipeEncoder)

    assert Interface.format(
             :error,
             [
               "Postgrex.Protocol",
               32,
               40,
               "#PID<0.1937.0>",
               ") failed to connect: "
               | "** (Postgrex.Error) FATAL 3D000 (invalid_catalog_name): database \"db\" does not exist"
             ],
             {{2018, 10, 18}, {9, 48, 35, 571}},
             []
           ) ==
             "Postgrex.Protocol (#PID<0.1937.0>) failed to connect: ** (Postgrex.Error) FATAL 3D000 (invalid_catalog_name): database \"db\" does not exist"
  end
end
