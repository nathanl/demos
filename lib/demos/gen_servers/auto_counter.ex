defmodule Demos.AutoCounter do
  @moduledoc """
  This GenServer increments a counter, over and over.
  We can ask it for the count at any time.

  Run `iex -S mix` and try the following.
  Run `LOG_LEVEL=debug iex -S mix` to also see the debug statements.

      iex> {:ok, pid} = Demos.AutoCounter.start_link(interval: 10_000)
      iex> Demos.AutoCounter.get_count(pid)
      # wait a while
      iex> Demos.AutoCounter.get_count(pid)
  """
  use GenServer
  require Logger

  ## Public Interface
  # These functions run in the process which calls them (generally the client,
  # although technically the server could call them on itself, but that would
  # be wacky.)
  
  # Starts the GenServer.
  # This specific function is required for starting in a supervision tree (a
  # topic for another day).
  # Whatever it hands to `GenServer.start_link` is given to the new process via
  # `init/1`.
  def start_link(opts) do
    Logger.debug "start_link: #{inspect(self())}"
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_count(server) do
    Logger.debug "get_count: #{inspect(self())}"
    GenServer.call(server, :get_count)
  end

  ## Callbacks
  # These functions run in the GenServer process.
  # Their special return values tells GenServer what to do next.
  
  # This is the first thing that the new process runs. Its receives
  # the arguments given in `GenServer.start_link/3`.
  @impl GenServer
  def init(opts) do
    Logger.debug "init: #{inspect(self())}"
    schedule_count(Keyword.get(opts, :interval, 1_000))
    {:ok, 0}
  end

  # We need a `handle_call` for every `GenServer.call`
  @impl GenServer
  def handle_call(:get_count, _from, counter) do
    Logger.debug "handle_call get_count: #{inspect(self())}"
    {:reply, counter, counter}
  end

  # handle_info is for generic messages, like `send(pid, :hi)`.
  # By default, it's defined to do nothing.
  # If we override that to do something, we need a "catch all"
  # clause to handle unexpected messages (probably by doing nothing).
  @impl GenServer
  def handle_info({:count, interval_ms}, counter) do
    Logger.debug "count: #{inspect(self())}"
    schedule_count(interval_ms)
    {:noreply, counter + 1}
  end

  # ignore unexpected messages.
  @impl GenServer
  def handle_info(msg, counter) do
    Logger.warn "unexpected message: #{inspect(msg)}"
    {:noreply, counter}
  end

  ## Private functions
  # These functions run in the process which calls them (generally the server,
  # although technically the public functions could call them, but that would
  # be wacky.)
  defp schedule_count(interval_ms) do
    Process.send_after(self(), {:count, interval_ms}, interval_ms)
  end
end
