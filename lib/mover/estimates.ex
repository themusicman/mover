defmodule Mover.Estimates do
  @moduledoc """
  The Estimates context.
  """
  alias Mover.Estimates.Estimate
  alias Mover.Repo
  import Ecto.Query, warn: false
  require Logger

  @doc """
  Returns the list of estimates.
  """
  def list_estimates do
    Repo.all(Estimate)
  end

  @doc """
  Gets a single estimate.

  Raises `Ecto.NoResultsError` if the Estimate does not exist.
  """
  def get_estimate!(id), do: Repo.get!(Estimate, id)

  @doc """
  Creates a estimate.
  """
  def create_estimate(attrs \\ %{}) do
    %Estimate{}
    |> Estimate.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a estimate.
  """
  def update_estimate(%Estimate{} = estimate, attrs) do
    estimate
    |> Estimate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Update a failed estimate
  """
  def update_failed_estimate(%Estimate{} = estimate, attrs) do
    estimate
    |> Estimate.failed_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a estimate.
  """
  def delete_estimate(%Estimate{} = estimate) do
    Repo.delete(estimate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking estimate changes.
  """
  def change_estimate(%Estimate{} = estimate, attrs \\ %{}) do
    Estimate.changeset(estimate, attrs)
  end

  @doc """
  Hard coded cost adjustments used to calculate an estimate for the cost of a move
  """
  @spec standard_rate() :: float()
  def standard_rate() do
    3.0
  end

  @doc """
  Hard coded cost adjustments used to calculate an estimate for the cost of a move
  """
  @spec cost_adjustments() :: [{String.t(), float()}]
  def cost_adjustments() do
    [
      {"Studio Apartment", 0.8},
      {"One Bedroom", 0.9},
      {"Two Bedroom", 1.0},
      {"Three Bedroom", 1.25},
      {"Greater than three bedrooms", 1.5}
    ]
  end

  defp handle_failed(estimate, error) do
    Logger.error("#{__MODULE__}.handle_failed error=#{inspect(error)}")

    case update_failed_estimate(estimate, %{status: :failed}) do
      {:ok, estimate} -> estimate
      _ -> estimate
    end
  end

  @doc """
  Calculates the cost of the estimate
  """
  @spec update_cost(Estimate.t()) :: Estimate.t()
  def update_cost(%Estimate{} = estimate) do
    try do
      case Mover.Distance.calculate(estimate.origin.zip, estimate.destination.zip) do
        %Mover.Distance{origin: origin, destination: destination, distance: distance} ->
          case Money.parse(distance * estimate.standard_rate * estimate.cost_adjustment) do
            {:ok, cost} ->
              case update_estimate(estimate, %{
                     "origin" => %{
                       "id" => estimate.origin.id,
                       "city" => origin.city,
                       "state" => origin.state,
                       "zip" => origin.zip
                     },
                     "destination" => %{
                       "id" => estimate.destination.id,
                       "city" => destination.city,
                       "state" => destination.state,
                       "zip" => destination.zip
                     },
                     "distance" => distance,
                     "cost" => cost,
                     "status" => :complete
                   }) do
                {:ok, estimate} ->
                  estimate

                error ->
                  handle_failed(estimate, error)
              end

            error ->
              handle_failed(estimate, error)
          end

        {:error, reason} ->
          handle_failed(estimate, reason)
      end
    rescue
      e ->
        handle_failed(estimate, e)
    end
  end
end
