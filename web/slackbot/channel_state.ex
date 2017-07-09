defmodule ChannelState do
  use Slack
  
  def transition(state, channel_id, message, slack) do
    channel_state = Map.get(state.channels, channel_id, %{state: :init})
    channel_state = transit(channel_state, state, message, slack)
    put_in(state, [:channels, channel_id], channel_state)
  end
  
  defp transit(channel_state = %{state: :init}, state, message, slack) do
    if Utils.mentions_user?(message.text) && Utils.trigger_phrase?(message.text) do
      IO.puts "transitioning from init state - start a DM"
      dm_id = lookup_direct_message_id(message.user, slack)
      IO.puts "dm_id: #{dm_id}."
      
      DMState.transition(state, dm_id, %{message | channel: dm_id}, slack)
    else
      channel_state
    end
  end
  
  defp transit(channel_state, _state, _message, _slack) do
    IO.puts "ChannelState ignoring #{inspect(channel_state)}."
  end
end
