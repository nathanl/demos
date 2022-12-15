defmodule Demos.CallAndCast do
  @moduledoc """
  This GenServer increments a counter, over and over.
  We can ask it for the count at any time.

  Run `iex -S mix` and try the following.
  Run `LOG_LEVEL=debug iex -S mix` to also see the debug statements.

      iex> {:ok, pid} = Demos.CallAndCast.start_link([])
      iex> Demos.CallAndCast.hand(:hi)
      iex> Demos.CallAndCast.toss(:ho)
      iex> Demos.CallAndCast.hand(:hee)
  """
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def hand(val) do
    GenServer.call(__MODULE__, {:hand, val})
  end

  def toss(val) do
    GenServer.cast(__MODULE__, {:toss, val})
  end

  @impl GenServer
  def init(opts) do
    {:ok, []}
  end

  @impl GenServer
  def handle_call({:hand, val}, _from, list) do
    updated_list = [val | list]
    # pretend this is really hard
    Process.sleep(3_000)
    {:reply, {:ok, updated_list}, updated_list}
  end

  @impl GenServer
  def handle_cast({:toss, val}, list) do
    # pretend this is really hard
    Process.sleep(3_000)
    {:noreply, [val | list]}
  end
end
