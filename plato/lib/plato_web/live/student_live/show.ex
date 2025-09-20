defmodule PlatoWeb.StudentLive.Show do
  use PlatoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "학생 상세")
     |> assign(:current_path, "/students")}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    student = Plato.Domain.get_student!(id, load: [:campus])
    
    {:noreply,
     socket
     |> assign(:student, student)
     |> assign(:page_title, "#{student.name} 상세")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    student = Plato.Domain.get_student!(id)
    {:ok, _} = Plato.Domain.destroy_student(student)

    {:noreply,
     socket
     |> put_flash(:info, "학생이 삭제되었습니다")
     |> push_navigate(to: ~p"/students")}
  end
end