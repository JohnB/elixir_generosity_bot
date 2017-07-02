defmodule StateMachine do
  use Slack

  def init(pid, state) do
    send(pid, {:message, "GenerosityBot started", "#general"})
    %{bot_pid: pid, current_state: :init}
  end
  
  def invited(message, slack, state) do
    creator_channel_id = lookup_direct_message_id(message.channel.creator, slack)
    invite_message = "Hey #{message.channel.creator} - thanks for inviting me!\n" <> help_text()
    send_message(invite_message, creator_channel_id, slack)
    state
  end
  
  def channel_message(message, slack, state) do
    IO.puts 'got channel message!'
    IO.puts inspect(message)
    state
  end
  
  def direct_message(message = %{type: "message", text: "help"}, slack, state) do
    dm = "Hi <@#{message.user}>! " <> help_text()
    IO.puts dm
    send_message(dm, message.channel, slack)
    state
  end
  def direct_message(message, slack, state) do
    IO.puts 'got direct message!'
    IO.puts inspect(message)
    state
  end
  
  def help_text do
    "Here is what I can do:\n*DM* `help` - to get a help message"
  end
end
