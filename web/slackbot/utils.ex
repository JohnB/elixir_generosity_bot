defmodule Utils do
  
  def help_text do
    "Here is what I can do:\n*DM* `help` - to get a help message"
  end
  
  def mentions_user?(text) do
    String.match?(text, ~r/<@\S+>/)
  end
  
  def trigger_phrase?(text) do
    String.match?(text, ~r/hbd/)
  end
  
  def affirmative?(text) do
    String.match?(text, ~r/y/i)
  end
  
  @doc """
  Given a string containing slack user IDs, extract the list of IDs
  Note that typing "@aaa" is translated, by slack, to "<@aaa>"
  e.g.  "hello <@aaa> and <@bbb> - woot!"  =>  ["aaa", "bbb"]
  """
  def slack_user_ids(text) do
    Regex.scan(~r/<@(\S+)>/, text) |> Enum.map( fn(array) -> List.last(array) end )
  end
end
