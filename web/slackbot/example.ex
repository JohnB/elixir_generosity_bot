defmodule SlackRtm do
  use Slack

  def handle_connect(slack, state) do
    IO.puts ""
    IO.puts "---"
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message", channel: "D" <> _}, slack, state) do
    IO.puts "received DIRECT message on #{message.channel}: #{inspect(message)}."
    dm = "Hi <@#{message.user}>!\nWho would you like to recognize today?"
    send_message(dm, message.channel, slack)

    {:ok, state}
  end
  def handle_event(message = %{type: "message", channel: "C" <> _}, slack, state) do
    IO.puts "received CHANNEL message on #{message.channel}: #{inspect(message)}."

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  # handle_info gets called when we send a message this way:
  #   send(rtm, {:message, "External message", "#johnb_qa4_test"})
  # but it isn't obvious that we'll send such things very often.
  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
