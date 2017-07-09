defmodule ChannelState do
  use Slack
  
  def transition(state, channel_id, message, slack) do
    channel_state = Map.get(state.channels, channel_id, %{state: :init})
    channel_state = transit(channel_state, message, slack)
    put_in(state, [:channels, channel_id], channel_state)
  end
  
  def transit(channel_state = %{state: :init}, message, slack) do
    IO.puts "transitioning from init state"
    channel_state
  end
end
