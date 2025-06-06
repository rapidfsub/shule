defmodule VictorWeb.HomeLive do
  use VictorWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.form :let={form} for={%{}} id="form" phx-change="validate">
      <.input field={form[:price]} type="number" label="Price" />
    </.form>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("validate", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
