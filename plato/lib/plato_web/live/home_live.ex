defmodule PlatoWeb.HomeLive do
  use PlatoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "플라토 학원 관리 시스템")
     |> assign(:current_path, "/")
     |> load_dashboard_data()}
  end

  defp load_dashboard_data(socket) do
    {:ok, students} = Plato.Domain.list_students()
    {:ok, problems} = Plato.Domain.list_problems()
    {:ok, campuses} = Plato.Domain.list_campuses()

    socket
    |> assign(:students, students)
    |> assign(:problems, problems)
    |> assign(:campuses, campuses)
  end
end
