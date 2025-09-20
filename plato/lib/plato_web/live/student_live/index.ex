defmodule PlatoWeb.StudentLive.Index do
  use PlatoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "학생 명부")
     |> assign(:current_path, "/students")}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    student = Plato.Domain.get_student!(id)
    {:ok, _} = Plato.Domain.destroy_student(student)

    # Cinder 테이블은 자동으로 새로고침됩니다
    {:noreply, socket |> put_flash(:info, "학생이 삭제되었습니다")}
  end
end
