defmodule Monitor.Detector do

  @doc """
    Accepts state `%{ :max => max, :min => min, :distance => distance }`

    Returns `%Monitor.State{ distance, presence }`
  """
  def detect(state) do
    %Monitor.State{
      max: state.max,
      min: state.min,
      distance: state.distance,
      present: state |> detect_presence
    }
  end

  @doc """
    Accepts state `%{ :max => max, :min => min, :distance => distance }`

    Returns `%Monitor.State{ distance, presence }`
  """
  defp detect_presence(%{ :max => max, :min => min, :distance => distance })
       when distance <= min
       when distance < max, do: true

  @doc """
    Accepts state `%{ :max => max, :distance => distance }`

    Returns `%Monitor.State{ distance, presence }`
  """
  defp detect_presence(%{ :max => max, :distance => distance })
       when distance >= max, do: false

end
