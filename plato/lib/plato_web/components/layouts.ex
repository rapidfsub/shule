defmodule PlatoWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use PlatoWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    assigns = assign_new(assigns, :current_path, fn -> "" end)

    ~H"""
    <header class="bg-white dark:bg-gray-900 shadow-sm border-b border-gray-200 dark:border-gray-700">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
          <!-- Logo and Brand -->
          <div class="flex items-center">
            <.link navigate={~p"/"} class="flex items-center space-x-3">
              <div class="bg-blue-600 text-white px-3 py-2 rounded-lg font-bold text-lg">
                플라토
              </div>
              <span class="text-gray-600 dark:text-gray-300 text-sm">학원 관리 시스템</span>
            </.link>
          </div>
          
    <!-- Main Navigation -->
          <nav class="hidden md:flex space-x-8">
            <.nav_link href={~p"/"} current={@current_path}>
              <.icon name="hero-home" class="w-4 h-4 mr-2" /> 대시보드
            </.nav_link>
            <.nav_link href={~p"/students"} current={@current_path}>
              <.icon name="hero-academic-cap" class="w-4 h-4 mr-2" /> 학생명부
            </.nav_link>
            <.nav_link href={~p"/problems"} current={@current_path}>
              <.icon name="hero-document-text" class="w-4 h-4 mr-2" /> 문제은행
            </.nav_link>
          </nav>
          
    <!-- Theme Toggle -->
          <div class="flex items-center">
            <.theme_toggle />
          </div>
        </div>
      </div>
      
    <!-- Mobile Navigation -->
      <div class="md:hidden bg-gray-50 dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700">
        <div class="px-2 pt-2 pb-3 space-y-1">
          <.mobile_nav_link href={~p"/"} current={@current_path}>
            <.icon name="hero-home" class="w-4 h-4 mr-2" /> 대시보드
          </.mobile_nav_link>
          <.mobile_nav_link href={~p"/students"} current={@current_path}>
            <.icon name="hero-academic-cap" class="w-4 h-4 mr-2" /> 학생명부
          </.mobile_nav_link>
          <.mobile_nav_link href={~p"/problems"} current={@current_path}>
            <.icon name="hero-document-text" class="w-4 h-4 mr-2" /> 문제은행
          </.mobile_nav_link>
        </div>
      </div>
    </header>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      {render_slot(@inner_block)}
    </main>

    <.flash_group flash={@flash} />
    """
  end

  # Navigation link component for desktop
  attr :href, :string, required: true
  attr :current, :string, default: ""
  slot :inner_block, required: true

  def nav_link(assigns) do
    ~H"""
    <.link
      navigate={@href}
      class={[
        "flex items-center px-3 py-2 text-sm font-medium rounded-md transition-colors",
        if((String.starts_with?(@current, @href) && @href != "/") || @current == @href,
          do: "text-blue-600 bg-blue-50 dark:text-blue-400 dark:bg-blue-900/20",
          else:
            "text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-gray-100 hover:bg-gray-50 dark:hover:bg-gray-700"
        )
      ]}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  # Navigation link component for mobile
  attr :href, :string, required: true
  attr :current, :string, default: ""
  slot :inner_block, required: true

  def mobile_nav_link(assigns) do
    ~H"""
    <.link
      navigate={@href}
      class={[
        "flex items-center px-3 py-2 text-base font-medium rounded-md transition-colors",
        if((String.starts_with?(@current, @href) && @href != "/") || @current == @href,
          do: "text-blue-600 bg-blue-50 dark:text-blue-400 dark:bg-blue-900/20",
          else:
            "text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-gray-100 hover:bg-gray-50 dark:hover:bg-gray-700"
        )
      ]}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
