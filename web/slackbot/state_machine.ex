defmodule StateMachine do
  use Slack

  def init(state, pid) do
    send(pid, {:message, "GenerosityBot started", "#general"})
    %{bot_pid: pid, channels: %{}, dms: %{}}
  end
  
  def invited(state, message, slack) do
    creator_channel_id = lookup_direct_message_id(message.channel.creator, slack)
    invite_message = "Hey #{message.channel.creator} - thanks for inviting me!\n" <> help_text()
    send_message(invite_message, creator_channel_id, slack)
    state
  end
  
  def channel_message(state, message, slack) do
    IO.puts 'got channel message!'
    IO.puts inspect(message)
    state
  end
  
  def direct_message(state, message = %{type: "message", text: "help"}, slack) do
    dm = "Hi <@#{message.user}>! " <> help_text()
    IO.puts dm
    send_message(dm, message.channel, slack)
    state
  end
  def direct_message(state, message, slack) do
    IO.puts 'got direct message!'
    IO.puts inspect(message)
    state
  end
  
  def help_text do
    "Here is what I can do:\n*DM* `help` - to get a help message"
  end
end
