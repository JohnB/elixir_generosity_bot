defmodule StateMachine do
  use Slack

  def init(state) do
    %{current_state: :init}
  end
  
  def channel_message(message, slack, state) do
    IO.puts 'got channel message!'
    IO.puts inspect(message)
    state
  end
  
  def direct_message(message = %{type: "message", text: "help"}, slack, state) do
    dm = "Hi <@#{message.user}>!\nThis is where help would be..."
    IO.puts dm
    send_message(dm, message.channel, slack)
    state
  end
  
  def direct_message(message, slack, state) do
    IO.puts 'got direct message!'
    IO.puts inspect(message)
    state
  end
end
