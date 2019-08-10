defmodule Monitor.Application do
  use Application

  def start(_type, _args) do
    children = [
      { DynamicSupervisor, strategy: :one_for_one, name: Monitor.DynamicSupervisor }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Monitor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
