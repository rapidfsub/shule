defmodule VictorWeb.Mask do
  use VictorWeb, :html

  attr :id, :string, required: true
  attr :field, Phoenix.HTML.FormField, required: true
  attr :rest, :global

  slot :inner_block

  def new(assigns) do
    ~H"""
    <div id={@id} phx-hook="IMask" {@rest}>
      <div id={@id <> "_ignore"} phx-update="ignore">
        {render_slot(@inner_block)}
      </div>
      <input type="hidden" name={@field.name} value={@field.value} />
    </div>
    """
  end
end
