defmodule Demos.KeepingState do
  @moduledoc """
  In the Elixir/Erlang world, a process is like an object in that it can have state.
  The way to keep state is to recurse with the new state.

  Do something like this:

  iex> pid = Demos.KeepingState.go
  iex> send(pid, "hi")
  iex> send(pid, "ho")

  Then wait for it to log what it got.
  """

  @doc "Run the demo"
  def go do
    IO.inspect("spawning a process, send it what you like")
    spawn(fn -> listen([]) end)
  end

  def listen(state) when is_list(state) do
    receive do
      message ->
        listen([message | state])
    after
      10_000 ->
        IO.inspect([self(), "has state", state])
    end
  end
end
