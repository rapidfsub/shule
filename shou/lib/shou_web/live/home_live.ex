defmodule ShouWeb.HomeLive do
  use ShouWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="p-8">
      <ShouWeb.TomSelect.new id="tom_select" />
    </div>
    """
  end
end
