defmodule Counter do
  @moduledoc """
  Simple counter from [the docs](https://hexdocs.pm/elixir/Supervisor.html), to
  be supervised in a demo.
  """
  use GenServer

  def start_link(arg) when is_integer(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  ## Callbacks

  @impl true
  def init(counter) do
    {:ok, counter}
  end

  def get, do: GenServer.call(__MODULE__, :get)
  def bump, do: GenServer.call(__MODULE__, {:bump, 1})

  @impl true
  def handle_call(:get, _from, counter) do
    {:reply, counter, counter}
  end

  def handle_call({:bump, value}, _from, counter) do
    {:reply, counter, counter + value}
  end
end
