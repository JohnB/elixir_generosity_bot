defmodule SlackRtm do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, StateMachine.init(self, state)}
  end

  # Explicitly ignore a bunch of messages - but not a direct or "ambient" channel message
  def handle_event(message = %{type: "message", channel: "D" <> _}, slack, state) do
    {:ok, StateMachine.direct_message(message, slack, state)}
  end
  def handle_event(message = %{type: "message", channel: "C" <> _}, slack, state) do
    {:ok, StateMachine.channel_message(message, slack, state)}
  end
  def handle_event(%{type: "desktop_notification"}, _, state), do: {:ok, state}
  def handle_event(%{type: "hello"}, _, state), do: {:ok, state}
  def handle_event(%{type: "presence_change"}, _, state), do: {:ok, state}
  def handle_event(%{type: "reconnect_url"}, _, state), do: {:ok, state}
  def handle_event(%{type: "user_typing"}, _, state), do: {:ok, state}
  def handle_event(message, _, state) do
    IO.puts "unhandled message: #{inspect(message)}"
    {:ok, state}
  end

  # handle_info gets called when we send a message this way:
  #   send(pid, {:message, "External message", "#general"})
  # but it isn't obvious that we'll send such things very often.
  # Also, a non-existent channel crashes the bot!
  def handle_info({:message, text, channel}, slack, state) do
    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
