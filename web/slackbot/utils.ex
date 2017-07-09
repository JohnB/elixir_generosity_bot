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
end
