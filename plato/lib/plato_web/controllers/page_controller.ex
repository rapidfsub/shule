defmodule PlatoWeb.PageController do
  use PlatoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
