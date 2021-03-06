defmodule DMState do
  @moduledoc """
  Keep track of the state of a DM conversation with an end-user.
  """
  use Slack
  
  @doc """
  Public entry point for initiating a state transition for a DM.
  """
  def transition(state, channel_id, message, slack) do
    channel_state = Map.get(state.dms, channel_id, %{state: :init})
    channel_state = transit(channel_state, message, slack)
    put_in(state, [:dms, channel_id], channel_state)
  end
  
  @doc """
  Internal state transitions.
  """
  defp transit(channel_state, message = %{type: "message", text: "help"}, slack) do
    send_message(Utils.help_text(), message.channel, slack)
    channel_state
  end
  defp transit(channel_state, message = %{type: "message", text: "cancel"}, slack) do
    IO.puts "cancelling"
    %{state: :init}
  end
  defp transit(channel_state = %{state: :init}, message, slack) do
    if Utils.mentions_user?(message.text) && Utils.trigger_phrase?(message.text) do
      IO.puts "transitioning from DM init state"
      slack_user_ids = Utils.slack_user_ids(message.text)
      user_names = Enum.map(slack_user_ids, fn(id) -> slack.users[id].name end )
      
      question = "Would you like to give karma to #{Enum.join(user_names, ", ")}?"
      send_message(question, message.channel, slack)
      %{channel_state | state: :confirm}
    else
      channel_state
    end
  end
  defp transit(channel_state = %{state: :confirm}, message, slack) do
    if Utils.affirmative?(message.text) do
      send_message("Giving some kind of karma...", message.channel, slack)
      %{state: :init}
    else
      send_message("OK - some other time", message.channel, slack)
      %{state: :init}
    end
  end
end
