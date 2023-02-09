defmodule Demos.Supervisors do
  def start do
    children = [
      %{
        id: Counter,
        start: {Counter, :start_link, [5]},
      },
      %{
        id: Stringer,
        start: {Stringer, :start_link, [["larry"]]}
      }
    ]

    # Now we start the supervisor with the children and a strategy
    {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_all, name: DemoSupervisor)
  end
end

# Demos.Supervisors.start()
# Supervisor.which_children(DemoSupervisor)
# Counter.get()
# Counter.bump()
# Counter.get()
# Stringer.get()
# Stringer.add("moe")
# Stringer.get()
# Process.exit(Process.whereis(Stringer), :shutdown)
# Counter.get()
# Stringer.get()
