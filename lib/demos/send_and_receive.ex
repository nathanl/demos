defmodule Demos.SendAndReceive do
  @moduledoc """
  Performs simple arithmetic on two numbers.

  ## Examples
      
      iex> pid = spawn(Demos.SendAndReceive, :loop, [])
      #PID<0.162.0>
 
      iex> send(pid, {self(), :*, 1, 2})
      {#PID<0.161.0>, :*, 1, 2}

      iex> send(pid, {self(), :-, 2, 4})
      {#PID<0.161.0>, :-, 2, 4}

      iex> send(pid, :yo)
      I have no idea what you're talking about.
      {#PID<0.161.0>, :yo}

      iex> flush()
      2
      -2
      :ok

  """
  def loop do
    receive do
      {from, op, a, b} when op in ~w(+ - * /)a  ->
        send(from, apply(Kernel, op, [a, b]))

      _ ->
        IO.inspect [self(), "is aliveeeee"]
        raise "oh no!"
    end

    loop()
  end
end
