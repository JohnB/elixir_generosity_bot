defmodule Conversation do
  use GenServer

  def start_link(channel_id) do
    IO.puts('Conversation.start_link(#{channel_id})')

    GenServer.start_link(Conversation, %{current_state: :dm_start, channel_id: channel_id})
  end

  def handle_cast({:start_conversation, message, rtm_pid}, state) do
    IO.puts('start_conversation: message=#{inspect(message)}, rtm_pid=#{inspect(rtm_pid)}.')

    dm = "Hi <@#{message.user}>!\nWho would you like to recognize today?"
    IO.puts("hoping to send: #{dm}.")
    send(rtm_pid, {:message, dm, "#johnb_qa4_test"}) # TODO: figure out how to send as a DM

    {:noreply, state}
  end

  def handle_cast({:continue_conversation, message, rtm_pid}, state) do
    IO.puts('continue_conversation: message=#{inspect(message)}, rtm_pid=#{inspect(rtm_pid)}.')

    {:noreply, state}
  end

end
