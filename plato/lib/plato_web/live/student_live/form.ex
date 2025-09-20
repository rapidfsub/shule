defmodule PlatoWeb.StudentLive.Form do
  use PlatoWeb, :live_view
  alias AshPhoenix.Form

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:current_path, "/students")}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    student = Plato.Domain.get_student!(id)
    form = Form.for_update(student, :update) |> to_form()

    {:noreply,
     socket
     |> assign(:page_title, "학생 수정")
     |> assign(:student, student)
     |> assign(:form, form)
     |> load_campuses()}
  end

  def handle_params(_params, _url, socket) do
    form = Form.for_create(Plato.Student, :create) |> to_form()

    {:noreply,
     socket
     |> assign(:page_title, "새 학생 등록")
     |> assign(:student, nil)
     |> assign(:form, form)
     |> load_campuses()}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = Form.validate(socket.assigns.form.source, params) |> to_form()
    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save", %{"form" => params}, socket) do
    case Form.submit(socket.assigns.form.source, params: params) do
      {:ok, _student} ->
        {:noreply,
         socket
         |> put_flash(:info, "학생 정보가 저장되었습니다")
         |> push_navigate(to: ~p"/students")}

      {:error, form} ->
        {:noreply, assign(socket, :form, to_form(form))}
    end
  end

  defp load_campuses(socket) do
    {:ok, campuses} = Plato.Domain.list_campuses()
    campus_options = Enum.map(campuses, &{&1.name, &1.id})
    assign(socket, :campus_options, campus_options)
  end
end
