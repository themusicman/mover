defmodule MoverWeb.EstimateLive.Index do
  use MoverWeb, :live_view

  alias Mover.Estimates
  alias Mover.Estimates.Estimate
  alias Phoenix.PubSub
  import Flamel.Wrap, only: [noreply: 1, ok: 1]

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()

    socket
    |> stream(:estimates, Estimates.list_estimates())
    |> ok()
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket
    |> apply_action(socket.assigns.live_action, params)
    |> noreply()
  end

  defp subscribe() do
    # Lets listen for updates on estimates
    # This could be scoped to a particular user, organization, etc by
    # using a topic with an identifier in it. ex. "estimates:#{user_id}"
    PubSub.subscribe(Mover.PubSub, "estimates")
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
  def handle_event("delete", %{"id" => id}, socket) do
    estimate = Estimates.get_estimate!(id)
    {:ok, _} = Estimates.delete_estimate(estimate)

    {:noreply, stream_delete(socket, :estimates, estimate)}
  end

  # This happens when an estimate is saved in the form component
  @impl true
  def handle_info({MoverWeb.EstimateLive.FormComponent, {:saved, estimate}}, socket) do
    {:noreply, stream_insert(socket, :estimates, estimate)}
  end

  # This happens when an estimate is updated in the background.
  # ex. after the distance and cost has been calculated
  @impl true
  def handle_info({:estimate_updated, estimate}, socket) do
    socket
    |> stream_insert(:estimates, estimate, at: 0)
    |> noreply()
  end
end
