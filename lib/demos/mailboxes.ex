defmodule Demos.Mailboxes do
  @moduledoc """
  Show that processes have a mailbox.

  Note that any message which has no matching clause in `receive` will remain
  in the mailbox, occupying memory.

  Do something like this:

  iex> :observer.start() # processes tab, sort desc by MsgQ
  iex> Demos.Mailboxes.go

  Uncomment the catch-all clause to ensure the mailbox gets cleared out.

  Besides observer, you can use Activity Monitor or whatever your system has to
  see Erlang's memory usage.
  """

  @doc "Run the demo"
  def go do
    pid = spawn(&listen/0)
    IO.puts(["#{inspect(self())} will send some messages"])
    send(pid, {:message, "Hello"})
    send(pid, {:gesture, "(sticks out tongue)", self()})
    send(pid, {:present, "(an unremarkable pebble)"})
    Process.sleep(2_000)
    send(pid, {:message, "I like your socks"})
    send(pid, {:gesture, "(stands on head)", self()})
    send(pid, {:present, "(a live beetle)"})
    # send a metric boatload of messages
    for _i <- 1..1_000_000 do
      send(pid, {:present, "(a grain of sand)"})
    end

    Process.sleep(2_000)
    {:messages, messages} = :erlang.process_info(self(), :messages)

    IO.puts(
      "original process #{inspect(self())} about to die. Mailbox contains #{inspect(messages)}"
    )

    send(pid, {:message, "See ya later"})
    :ok
  end

  defp listen do
    receive do
      # handle a message
      {:message, message} ->
        IO.puts(["spawned process #{inspect(self())} got message: ", message])
        listen()

      # handle a gesture
      {:gesture, gesture, from} ->
        IO.puts("spawned process #{inspect(self())} will send a reply")
        send(from, "I see your gesture '#{gesture}'")
        listen()

        # catch-all clause
        _ ->
          # ignore
          listen()
    after
      4_000 ->
        # Normally we don't look at the mailbox directly. It's impolite and embarrasses the process.
        {:messages, messages} = :erlang.process_info(self(), :messages)

        IO.puts(
          "#{inspect(self())} about to die. Mailbox contains #{Enum.count(messages)} messages"
        )

        # uncomment only if you comment out the sending of many messages above
        # IO.inspect messages
    end
  end
end
