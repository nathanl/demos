defmodule Demos.Scheduling do
  @moduledoc """
  The BEAM (the Erlang VM) uses preemptive multitasking (basically, with some
  caveats).
  This means that whether a process is sleeping, waiting on IO, or calculating
  furiously, the scheduler will only let the process run a certain number of
  "reducions" (basically function calls) before the scheduler says "OK, pause
  there while I let someone else have a turn."

  Watch CPU usage of Erlang while this demo runs - you'll see it spike to maybe
  700%, showing that multiple cores are being fully used.

  iex> Demos.Scheduling.go()
  """

  @doc "Run the demo"
  def go do
    count = System.schedulers_online()

    # sleepy processes
    for _i <- 1..count do
      spawn(fn -> Process.sleep(10_000) end)
    end

    # busy processes
    for _i <- 1..count do
      spawn(fn -> IO.inspect([self(), " calculated ", fib(43)]) end)
    end

    # In theory, at this point, all proccessors on the system are very busy
    # calculating fibonacci numbers.
    # But this still gets to run.
    for _i <- 1..10 do
      IO.inspect(["original process ", self(), " is still getting a turn to run..."])
      Process.sleep(1_000)
    end
  end

  @doc """
  Naively generate fibbonacci sequence numbers.
  The amount of work this takes scales up very quickly.
  `fib(45)` takes maybe 10 seconds on my MacBook in 2022.
  """
  def fib(0), do: 0
  def fib(1), do: 1

  def fib(n) when is_integer(n) and n > 1 do
    fib(n - 1) + fib(n - 2)
  end
end
