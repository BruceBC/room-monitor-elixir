defmodule Monitor do

  alias Monitor.Server

  def start_link(state \\ %{ :max => 151, :min => 19, :distance => 151 }) do
    DynamicSupervisor.start_child(Monitor.DynamicSupervisor, {Server, state})
  end



  defdelegate stop(pid), to: Server
  defdelegate get(pid), to: Server
  defdelegate update(pid, state), to: Server

end
