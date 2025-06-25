defmodule ShouWeb.TomSelect do
  use ShouWeb, :live_component

  attr :id, :string, required: true
  attr :create, :boolean, default: false
  attr :persist, :boolean, default: false
  attr :create_on_blur, :boolean, default: false

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
    <div
      id={@id}
      phx-hook="TomSelect"
      data-create={to_string(@create)}
      data-create-on-blur={to_string(@create_on_blur)}
      data-persist={to_string(@persist)}
    >
      <select></select>
    </div>
    """
  end
end
