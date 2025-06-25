defmodule ShouWeb.TomSelect do
  use ShouWeb, :live_component

  attr :id, :string, required: true
  attr :tom_select_settings, :map, default: %{}

  def new(assigns) do
    assigns = assigns |> assign(module: __MODULE__)

    ~H"""
    {live_component(assigns)}
    """
  end

  @impl Phoenix.LiveComponent
  def mount(socket) do
    socket = socket |> assign(tom_select_settings: %{})
    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    socket =
      if assigns.tom_select_settings == socket.assigns.tom_select_settings do
        socket
      else
        socket |> push_event("#{assigns.id}:settings", assigns.tom_select_settings)
      end

    socket = socket |> assign(assigns)
    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div id={@id} phx-hook="TomSelect">
      <select></select>
    </div>
    """
  end
end
