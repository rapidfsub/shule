defmodule VictorWeb.HomeLive do
  use VictorWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    form = to_form(%{}, as: :form)
    socket = socket |> assign(form: form)
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.form for={@form} id="form" phx-change="validate">
      <.input field={@form[:name]} label="Name" />
      <VictorWeb.Mask.new
        id="price_mask"
        field={@form[:price]}
        data-mask="Number"
        data-thousands-separator=","
        data-autofix="true"
      >
        <.input field={@form[:price]} label="Price" />
      </VictorWeb.Mask.new>
    </.form>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"form" => params}, socket) do
    form = to_form(params, as: :form)
    socket = socket |> assign(form: form)
    {:noreply, socket}
  end
end
