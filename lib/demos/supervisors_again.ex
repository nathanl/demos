defmodule Demos.SupervisorsAgain do
  def start do
    children = [
      %{
        id: Stringer,
        start: {Stringer, :start_link, [["larry"]]},
        # - :permanent = always restart this process if it terminates
        # - :transient = only restart this process if it terminates abnormally
        #    (normally = via :normal, :shutdown, or {:shutdown, term}; :normal
        #    doesn't cause linked processes to exit and :shutdown does.)
        # - :temporary = never restart this process
        restart: :transient,
        # Use `Process.exit(pid, :kill)` to instantly terminate this
        shutdown: :brutal_kill
      },
      %{
        id: Counter,
        start: {Counter, :start_link, [5]},
        # Restart any time the process terminates
        restart: :permanent,
        # Use `Process.exit(pid, :shutdown)` to gracefully terminate this,
        # then resort to `Process.exit(pid, :kill)` if it's alive after 3 seconds.
        # (`:infinity` is also allowed; then `:kill` would never be used.)
        shutdown: 3_000
      }
    ]

    # Now we start the supervisor with the children and a strategy
    {:ok, pid} =
      Supervisor.start_link(
        children,
        # - :one_for_all = if one child terminates and needs restarting, restart all
        # - :one_for_one = only restart the one that terminated
        # - :rest_for_one = restart the one that terminated and all the ones that
        #   started after it
        strategy: :rest_for_one,
        # if a child terminates 3 times in 5 seconds
        max_restarts: 3,
        max_seconds: 5,
        name: DemoSupervisor
      )
  end
end

# Demos.SupervisorsAgain.start()
# Supervisor.which_children(DemoSupervisor)
# Process.exit(Process.whereis(Stringer), :kill)
# Supervisor.which_children(DemoSupervisor)
# Process.exit(Process.whereis(Stringer), :shutdown)
# Supervisor.which_children(DemoSupervisor)
