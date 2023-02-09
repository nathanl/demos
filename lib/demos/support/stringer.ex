defmodule Stringer do
  @moduledoc """
  Simple accumulator to be supervised in a demo.
  """
  use GenServer

  def start_link(arg) when is_list(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  ## Callbacks

  @impl true
  def init(strings) do
    {:ok, strings}
  end

  def get, do: GenServer.call(__MODULE__, :get)
  def add(string), do: GenServer.call(__MODULE__, {:add, string})

  @impl true
  def handle_call(:get, _from, strings) do
    {:reply, strings, strings}
  end

  def handle_call({:add, string}, _from, strings) do
    updated = [string | strings]
    {:reply, updated, updated}
  end
end
