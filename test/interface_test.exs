defmodule DummyEncoderSuccess do
  def encode!(_), do: ""
end

defmodule DummyEncoderFail do
  def encode!(_), do: raise("foo")
end

defmodule EncoderExpecter do
  def encode!(map) do
    if map["ts"] != "2014-12-30 12:06:30.100", do: raise("ts not ok")
    if map["msg"] != "hello world", do: raise("msg not ok")
    if map["level"] != :error, do: raise("level not ok")
    if map[:foo] == nil, do: raise("foo not ok")
    ""
  end
end

defmodule Logger.Formatter.InterfaceTest do
  use ExUnit.Case

  alias Logger.Formatter.Interface

  test "work" do
    Application.put_env(:logger, :encoder, DummyEncoderSuccess)

    assert Interface.format(nil, nil, nil, nil) ==
             "{\"msg\": \"could not format: {nil, nil, nil, nil}\"}\n"

    assert Interface.format(:error, nil, nil, nil) ==
             "{\"msg\": \"could not format: {:error, nil, nil, nil}\"}\n"

    assert Interface.format(:error, "hello world", nil, nil) ==
             "{\"msg\": \"could not format: {:error, \"hello world\", nil, nil}\"}\n"

    ts = {{2014, 12, 30}, {12, 6, 30, 100}}

    assert Interface.format(:error, "hello world", ts, nil) ==
             "{\"msg\": \"could not format: {:error, \"hello world\", #{inspect(ts)}, nil}\"}\n"

    assert Interface.format(:error, "hello world", ts, []) == ""

    assert Interface.format(:error, "hello world", ts, foo: "bar") == ""

    Application.put_env(:logger, :encoder, DummyEncoderFail)

    assert Interface.format(:error, "hello world", ts, foo: "bar") ==
             "{\"msg\": \"could not format: {:error, \"hello world\", {{2014, 12, 30}, {12, 6, 30, 100}}, [foo: \"bar\"]}\"}\n"

    Application.put_env(:logger, :encoder, EncoderExpecter)

    assert Interface.format(:error, "hello world", ts, foo: "bar") == ""

    assert Interface.format(:error, "hello world", ts, foo: "bar", ts: "foobar") == ""
  end
end
