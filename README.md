# Demos

Little demos of how Elixir works.

Each module in `/lib` is a demo. To run one:

- `iex -S mix`
- Maybe `:observer.start()` and/or open Activity Monitor or whatever you use to watch memory usage on your OS
- Run a demo - for example, `Demos.Mailboxes.go()`
- Maybe tweak the code, `recompile`, and run again
