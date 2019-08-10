defmodule MonitorServerTest do
  use ExUnit.Case

  alias Monitor.Server

  @moduletag :capture_log

  doctest Server

  test "module exists" do
    assert is_list(Server.module_info())
  end

  test "starts an agent with default params" do
    assert { :ok, pid } = Server.start_link()
  end

  test "starts an agent with custom params" do
    server = %{ :max => 100, :min => 10, :distance => 50 }
      |> Server.start_link()

    assert { :ok, pid } = server
  end

  test "retrieves state from agent" do
    %{ :max => 100, :min => 10, :distance => 50 }
    |> Server.start_link

    assert %Monitor.State{ distance: 50, present: true } = Server.get()
  end

  test "updates causes present to be true when distance < min" do
    %{ :max => 100, :min => 10, :distance => 50 }
    |> Server.start_link

    %{ :distance => 10 }
    |> Server.update()

    assert %Monitor.State{ distance: 10, present: true } = Server.get()
  end

  test "updates causes present to be true when distance >= min and <= max" do
    %{ :max => 100, :min => 10, :distance => 50 }
    |> Server.start_link

    %{ :distance => 99 }
    |> Server.update()

    assert %Monitor.State{ distance: 99, present: true } = Server.get()
  end

  test "updates causes present to be false when distance >= max" do
    %{ :max => 100, :min => 10, :distance => 50 }
    |> Server.start_link

    %{ :distance => 100 }
    |> Server.update()

    assert %Monitor.State{ distance: 100, present: false } = Server.get()
  end

end
