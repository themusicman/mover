defmodule MoverWeb.AppComponents do
  @moduledoc """
  A set of components for this application
  """
  use Phoenix.Component

  def spinner(assigns) do
    ~H"""
    <div
      class="animate-spin top-1 relative inline-block w-4 h-4 border-[3px] border-current border-t-transparent text-indigo-600 rounded-full"
      role="status"
    >
      <span class="sr-only">Loading...</span>
    </div>
    """
  end
end
