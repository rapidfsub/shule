defmodule PlatoWeb.StudentLive.FormComponent do
  use PlatoWeb, :live_component
  alias AshPhoenix.Form

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>학생 정보를 입력해주세요</:subtitle>
      </.header>

      <.form
        for={@form}
        id="student-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="이름" />
        <.input field={@form[:phone]} type="text" label="연락처" />
        <.input field={@form[:grade]} type="number" label="학년" />
        <.input
          field={@form[:campus_id]}
          type="select"
          label="캠퍼스"
          prompt="캠퍼스를 선택하세요"
          options={@campus_options}
        />
        
        <div class="mt-6 flex items-center justify-end gap-x-6">
          <.button type="submit" phx-disable-with="저장 중...">
            학생 저장
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{student: student} = assigns, socket) do
    {:ok, campuses} = Plato.Domain.list_campuses()
    campus_options = Enum.map(campuses, &{&1.name, &1.id})

    form =
      if student.id do
        Form.for_update(student, :update)
      else
        Form.for_create(Plato.Student, :create)
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(form))
     |> assign(:campus_options, campus_options)}
  end

  @impl true
  def handle_event("validate", %{"form" => student_params}, socket) do
    form = Form.validate(socket.assigns.form.source, student_params)
    {:noreply, assign(socket, form: to_form(form))}
  end

  def handle_event("save", %{"form" => student_params}, socket) do
    save_student(socket, socket.assigns.action, student_params)
  end

  defp save_student(socket, :edit, student_params) do
    case Form.submit(socket.assigns.form.source, params: student_params) do
      {:ok, student} ->
        notify_parent({:saved, student})

        {:noreply,
         socket
         |> put_flash(:info, "학생 정보가 수정되었습니다")
         |> push_patch(to: socket.assigns.patch)}

      {:error, form} ->
        {:noreply, assign(socket, form: to_form(form))}
    end
  end

  defp save_student(socket, :new, student_params) do
    case Form.submit(socket.assigns.form.source, params: student_params) do
      {:ok, student} ->
        notify_parent({:saved, student})

        {:noreply,
         socket
         |> put_flash(:info, "학생이 등록되었습니다")
         |> push_patch(to: socket.assigns.patch)}

      {:error, form} ->
        {:noreply, assign(socket, form: to_form(form))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
