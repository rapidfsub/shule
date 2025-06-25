defmodule ShouWeb.PageController do
  use ShouWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
