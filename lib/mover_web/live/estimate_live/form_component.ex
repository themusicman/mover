defmodule MoverWeb.EstimateLive.FormComponent do
  use MoverWeb, :live_component

  alias Mover.Estimates
  alias Phoenix.PubSub

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage estimate records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="estimate-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.inputs_for :let={f_origin} field={@form[:origin]}>
          <.input field={f_origin[:zip]} type="number" label="Origin zip" />
        </.inputs_for>

        <.inputs_for :let={f_destination} field={@form[:destination]}>
          <.input field={f_destination[:zip]} type="number" label="Destination zip" />
        </.inputs_for>

        <.input
          prompt="Pick one"
          field={@form[:cost_adjustment]}
          type="select"
          options={Mover.Estimates.cost_adjustments()}
          label="Size of move"
        />
        <:actions>
          <.button phx-disable-with="Saving...">Get Estimate</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{estimate: estimate} = assigns, socket) do
    changeset = Estimates.change_estimate(estimate)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"estimate" => estimate_params}, socket) do
    changeset =
      socket.assigns.estimate
      |> Estimates.change_estimate(estimate_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"estimate" => estimate_params}, socket) do
    save_estimate(socket, socket.assigns.action, estimate_params)
  end

  defp save_estimate(socket, :new, estimate_params) do
    estimate_params = Map.put(estimate_params, "standard_rate", Mover.Estimates.standard_rate())

    case Estimates.create_estimate(estimate_params) do
      {:ok, estimate} ->
        notify_parent({:saved, estimate})

        Flamel.Task.background(fn ->
          updated_estimate = Mover.Estimates.update_cost(estimate)
          PubSub.broadcast(Mover.PubSub, "estimates", {:estimate_updated, updated_estimate})
        end)

        {:noreply,
         socket
         |> put_flash(:info, "Estimate created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
