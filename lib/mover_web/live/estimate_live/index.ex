defmodule MoverWeb.EstimateLive.Index do
  use MoverWeb, :live_view

  alias Mover.Estimates
  alias Mover.Estimates.Estimate

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :estimates, Estimates.list_estimates())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Estimate")
    |> assign(:estimate, Estimates.get_estimate!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Estimate")
    |> assign(:estimate, %Estimate{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Estimates")
    |> assign(:estimate, nil)
  end

  @impl true
  def handle_info({MoverWeb.EstimateLive.FormComponent, {:saved, estimate}}, socket) do
    {:noreply, stream_insert(socket, :estimates, estimate)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    estimate = Estimates.get_estimate!(id)
    {:ok, _} = Estimates.delete_estimate(estimate)

    {:noreply, stream_delete(socket, :estimates, estimate)}
  end
end
