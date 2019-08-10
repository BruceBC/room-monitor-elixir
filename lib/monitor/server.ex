defmodule Monitor.Server do

  alias Monitor.Detector

  use Agent, restart: :transient

  @doc """
    Accepts state `%{ :max => max, :min => min, :distance => distance }`
    Default params `%{ :max => 151, :min => 19, :distance => -1 }`

    Returns `{:ok, pid}`
  """
  def start_link(state \\ %{ :max => 151, :min => 19, :distance => 151 }) do
    Agent.start_link(fn -> Detector.detect(state) end)
  end

  def stop(pid) do
    Agent.stop(pid, :shutdown)
  end

  @doc """
    Accepts state `%{ :max => max, :min => min, :distance => distance }`

    Returns `%Monitor.State{ distance, presence }`
  """
  def get(pid) do
    Agent.get(pid, & &1)
  end

  @doc """
    Accepts state `%{ :max => max, :min => min, :distance => distance }`

    Returns `%Monitor.State{ distance, presence }`
  """
  def update(pid, state) do
    Agent.update(pid, fn old -> merge(old, state) end)
    get(pid)
  end

  @doc """
    Accepts
      old_state `%{ :max => max, :min => min, :distance => distance }`
      new_state `%{ :max => max, :min => min, :distance => distance }`

    Returns `%Monitor.State{ distance, presence }`
  """
  defp merge(old, state) do
    old
    |> Map.merge(state)
    |> Detector.detect()
  end

end
