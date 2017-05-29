defmodule Conversation do
  use GenServer

  def start_link(channel_id) do
    IO.puts('Conversation.start_link(#{channel_id})')

    GenServer.start_link(Conversation, %{current_state: :dm_start, channel_id: channel_id})
  end

  def set_conversation_details(conversation, our_name, their_name, channel_id) do
  end
end
