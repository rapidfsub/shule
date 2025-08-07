defmodule ShouWeb.TomSelect do
  use ShouWeb, :live_component

  attr :id, :string, required: true
  attr :is_remote, :boolean, default: false
  attr :load_fun, :any, default: nil
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
        socket |> push_settings(assigns)
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

  @impl Phoenix.LiveComponent
  def handle_event("load", %{"query" => query, "keyset" => keyset}, socket) do
    payload = socket.assigns.load_fun.(query, keyset)
    {:reply, payload, socket}
  end

  defp push_settings(socket, assigns) do
    payload =
      convert_keys(%{
        settings: assigns.tom_select_settings,
        is_remote: assigns.is_remote
      })

    socket |> push_event("#{assigns.id}:settings", payload)
  end

  defp convert_keys(map) do
    for {k, v} <- map, into: %{} do
      {lower_camelize(k), v}
    end
  end

  defp lower_camelize(text) do
    text
    |> to_string()
    |> Macro.camelize()
    |> String.replace(~r/^./, &String.downcase/1)
  end
end
