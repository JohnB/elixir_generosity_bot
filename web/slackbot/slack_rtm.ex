"""
  state is expected to contain a hash of conversations
     %{conversations: %{"C1234" => #PID<0.434.0>}}
"""
defmodule SlackRtm do
  use Slack

  def handle_connect(slack, state) do
    IO.puts ""
    IO.puts "---"
    IO.puts "Connected as #{slack.me.name} with state #{inspect(state)}."

    {:ok, state}
  end

  def handle_event(message = %{type: "message", channel: "C" <> _}, slack, state) do
    IO.puts "received CHANNEL message on #{message.channel}: #{inspect(message)}."

    # open a DM when we see a trigger message
    if trigger_word?(message.text) do
      {:ok, conversation_pid, new_state} = fetch_conversation_pid(message.channel, state)
      IO.puts "C-message: #{inspect(new_state)}."
      # send(conversation_pid, ...
    else
      IO.puts "C-message: no trigger"
      new_state = state
    end

    {:ok, new_state}
  end
  def handle_event(message = %{type: "message", channel: "D" <> _, text: "[eBot]"}, _, state) do
    # TODO: find a better way to ignore our own eBot messages.
    {:ok, state}
  end
  def handle_event(message = %{type: "message", channel: "D" <> _}, slack, state) do

    IO.puts "received DIRECT message on #{message.channel}: #{inspect(message)}."
    {:ok, conversation_pid, new_state} = fetch_conversation_pid(message.channel, state)
    IO.puts "D-message: #{inspect(new_state)}"

    # TODO: move this DM into the Conversation module
    dm = "Hi <@#{message.user}>!\nWho would you like to recognize today?"
    ebot_message(dm, message.channel, slack)

    {:ok, new_state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  defp fetch_conversation_pid(channel_name, state) do
    IO.puts('fetch_conversation_pid(#{channel_name}, #{inspect(state)})')
    if Map.has_key?(state.conversations, channel_name) do
      pid = Map.fetch(state.conversations, channel_name)
    else
      IO.puts('starting conversation for #{channel_name}')
      {:ok, pid} = Conversation.start_link(channel_name)
      updated_conversations = Map.put(state.conversations, channel_name, pid)
      state = %{state | conversations: updated_conversations}
      IO.puts('state.conversations=#{inspect(state.conversations)}.')
    end
    {:ok, pid, state}
  end

  # handle_info gets called when we send a message this way:
  #   send(rtm, {:message, "External message", "#johnb_qa4_test"})
  # but it isn't obvious that we'll send such things very often.
  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    ebot_message("[eBot]" <> text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

  def ebot_message(text, channel, slack) do
    send_message("[eBot] " <> text, channel, slack)
  end

  @triggers %{
    '1': ~r/good\b.*\bjob|great\b.*\bjob|awesome\b.*\bjob|great\b.*\bwork|nice\b.*\bjob|nice\b.*\bwork|way to go/i,
    '2': ~r/happy\b.*\bbirthday|happy\b.*\bbday|hbd|happy\b.*\bburfday|happy\b.*\bbirtday|happy day of birth|happy\b.*\bbarfday|happy b'?day|happiest\b.*\bbirthday/i,
    '3': ~r/happy\b.*\banniversary|happy work anniversary|happy\b.*\bworkiversary|happiest\b.*\banniversary/i,
    '4': ~r/congrats|congratulations/i,
    '5': ~r/thanks|thank yous?|thx|gracias|arigato/i
  }

  # Check if the given text agains our trigger regexes
  def trigger_word?(text) do
    Map.values(@triggers)
    |>  Enum.any?(fn(value) -> Regex.match?(value, text) end)
  end

end
