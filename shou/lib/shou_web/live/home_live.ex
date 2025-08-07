defmodule ShouWeb.HomeLive do
  use ShouWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(:timer.seconds(1), :tick)
    end

    socket = socket |> assign(:count, 0)
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:tick, socket) do
    socket = socket |> update(:count, &(&1 + 1))
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="p-8 flex flex-col items-start">
      {@count}

      <ShouWeb.TomSelect.new
        id="tom_select"
        tom_select_settings={
          %{
            create: true,
            persist: true,
            createOnBlur: true,
            maxOptions: 500,
            plugins: ["virtual_scroll"]
          }
        }
        load_fun={
          fn query, keyset ->
            page_opts =
              if keyset do
                [after: keyset]
              else
                []
              end

            page = Shou.Domain.list_objs_by_name!(query, page: page_opts)
            last = Enum.at(page.results, -1)

            keyset =
              if last do
                Ash.Resource.get_metadata(last, :keyset)
              end

            items =
              for obj <- page.results do
                %{text: obj.name, value: obj.id}
              end

            %{items: items, after: page.more?, keyset: keyset}
          end
        }
        is_remote
      />
    </div>
    """
  end
end
