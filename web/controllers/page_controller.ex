defmodule ElixirGenerosityBot.PageController do
  use ElixirGenerosityBot.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
