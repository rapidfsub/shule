defmodule PlatoWeb.ProblemLive.Show do
  use PlatoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "문제 상세")
     |> assign(:current_path, "/problems")}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    problem = Plato.Domain.get_problem!(id, load: [:campus])
    
    {:noreply,
     socket
     |> assign(:problem, problem)
     |> assign(:page_title, "문제 상세")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    problem = Plato.Domain.get_problem!(id)
    {:ok, _} = Plato.Domain.destroy_problem(problem)

    {:noreply,
     socket
     |> put_flash(:info, "문제가 삭제되었습니다")
     |> push_navigate(to: ~p"/problems")}
  end

  defp subject_label(subject) do
    case subject do
      :math -> "수학"
      :english -> "영어"
    end
  end

  defp difficulty_label(difficulty) do
    case difficulty do
      :low -> "하"
      :medium -> "중"
      :high -> "상"
    end
  end

  defp difficulty_class(difficulty) do
    case difficulty do
      :low -> "bg-green-100 text-green-800"
      :medium -> "bg-yellow-100 text-yellow-800"
      :high -> "bg-red-100 text-red-800"
    end
  end

  defp subject_class(subject) do
    case subject do
      :math -> "bg-blue-100 text-blue-800"
      :english -> "bg-green-100 text-green-800"
    end
  end
end