defmodule MoverWeb.EstimateLive.FormComponent do
  use MoverWeb, :live_component

  alias Mover.Estimates

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
        <.input field={@form[:origin_zip]} type="text" label="Origin zip" />
        <.input field={@form[:destination_zip]} type="text" label="Destination zip" />
        <.input field={@form[:distance]} type="number" label="Distance" />
        <.input field={@form[:standard_rate]} type="number" label="Standard rate" />
        <.input field={@form[:cost_adjustment]} type="number" label="Cost adjustment" step="any" />
        <.input field={@form[:cost]} type="number" label="Cost" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Estimate</.button>
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

  defp save_estimate(socket, :edit, estimate_params) do
    case Estimates.update_estimate(socket.assigns.estimate, estimate_params) do
      {:ok, estimate} ->
        notify_parent({:saved, estimate})

        {:noreply,
         socket
         |> put_flash(:info, "Estimate updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_estimate(socket, :new, estimate_params) do
    case Estimates.create_estimate(estimate_params) do
      {:ok, estimate} ->
        notify_parent({:saved, estimate})

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
