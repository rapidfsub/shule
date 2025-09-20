defmodule PlatoWeb.ProblemLive.Index do
  use PlatoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "문제 은행")
     |> assign(:current_path, "/problems")}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    problem = Plato.Domain.get_problem!(id)
    {:ok, _} = Plato.Domain.destroy_problem(problem)

    # Cinder 테이블은 자동으로 새로고침됩니다
    {:noreply, socket |> put_flash(:info, "문제가 삭제되었습니다")}
  end
end
