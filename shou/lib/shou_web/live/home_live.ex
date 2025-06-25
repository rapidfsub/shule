defmodule ShouWeb.HomeLive do
  use ShouWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="p-8 flex flex-col items-start">
      <ShouWeb.TomSelect.new
        id="tom_select"
        tom_select_settings={%{create: true, persist: true, createOnBlur: true}}
        load_fun={
          fn _query ->
            for i <- 1..10 do
              %{text: "Item #{i}", value: i}
            end
          end
        }
        is_remote
      />
    </div>
    """
  end
end
