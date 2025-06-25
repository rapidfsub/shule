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
        tom_select_settings={
          %{
            create: true,
            persist: true,
            createOnBlur: true,
            valueField: "id",
            labelField: "name",
            searchField: "name"
          }
        }
        load_fun={
          fn _query ->
            for i <- 1..10 do
              %{id: i, name: "Item #{i}"}
            end
          end
        }
      />
    </div>
    """
  end
end
