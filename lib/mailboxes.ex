defmodule Demos.Mailboxes do
  @doc """
  Show that processes have a mailbox.

  Note that any message which has no matching clause in `receive` will remain
  in the mailbox, occupying memory.
  Uncomment the catch-all clause to ensure the mailbox gets cleared out.
  """

  def go do
    pid = spawn(&listen/0)
    IO.puts(["#{inspect(self())} will send some messages"])
    send(pid, {:message, "Hello"})
    send(pid, {:gesture, "(sticks out tongue)"})
    send(pid, {:present, "(an unremarkable pebble)"})
    Process.sleep(2_000)
    send(pid, {:message, "I like your socks"})
    send(pid, {:gesture, "(stands on head)"})
    send(pid, {:present, "(a live beetle)"})
    for _i <- 1..1_000_000 do
      send(pid, {:present, "(a grain of sand)"})
    end
    Process.sleep(2_000)
    send(pid, {:message, "See ya later"})
    :ok
  end

  def listen do
    receive do
      # handle a message
      {:message, message} ->
        IO.puts(["#{inspect(self())} got message: ", message])
        listen()

      # handle a gesture
      {:gesture, gesture} ->
        IO.puts(["#{inspect(self())} sees gesture: ", gesture])
        listen()

      # # catch-all clause
      # _ ->
      #   # ignore
      #   listen()
    after
      4_000 ->
        {:messages, messages} = :erlang.process_info(self(), :messages)
        IO.puts("#{inspect(self())} about to die. Mailbox contains #{Enum.count(messages)} messages")
        # IO.inspect messages
    end
  end
end
