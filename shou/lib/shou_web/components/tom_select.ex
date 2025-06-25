defmodule ShouWeb.TomSelect do
  use ShouWeb, :live_component

  attr :id, :string, required: true

  def new(assigns) do
    assigns = assigns |> assign(module: __MODULE__)

    ~H"""
    {live_component(assigns)}
    """
  end

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
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
