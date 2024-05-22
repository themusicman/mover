defmodule Mover.Estimates do
  @moduledoc """
  The Estimates context.
  """

  import Ecto.Query, warn: false
  alias Mover.Repo

  alias Mover.Estimates.Estimate

  @doc """
  Returns the list of estimates.

  ## Examples

      iex> list_estimates()
      [%Estimate{}, ...]

  """
  def list_estimates do
    Repo.all(Estimate)
  end

  @doc """
  Gets a single estimate.

  Raises `Ecto.NoResultsError` if the Estimate does not exist.

  ## Examples

      iex> get_estimate!(123)
      %Estimate{}

      iex> get_estimate!(456)
      ** (Ecto.NoResultsError)

  """
  def get_estimate!(id), do: Repo.get!(Estimate, id)

  @doc """
  Creates a estimate.

  ## Examples

      iex> create_estimate(%{field: value})
      {:ok, %Estimate{}}

      iex> create_estimate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_estimate(attrs \\ %{}) do
    %Estimate{}
    |> Estimate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a estimate.

  ## Examples

      iex> update_estimate(estimate, %{field: new_value})
      {:ok, %Estimate{}}

      iex> update_estimate(estimate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_estimate(%Estimate{} = estimate, attrs) do
    estimate
    |> Estimate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a estimate.

  ## Examples

      iex> delete_estimate(estimate)
      {:ok, %Estimate{}}

      iex> delete_estimate(estimate)
      {:error, %Ecto.Changeset{}}

  """
  def delete_estimate(%Estimate{} = estimate) do
    Repo.delete(estimate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking estimate changes.

  ## Examples

      iex> change_estimate(estimate)
      %Ecto.Changeset{data: %Estimate{}}

  """
  def change_estimate(%Estimate{} = estimate, attrs \\ %{}) do
    Estimate.changeset(estimate, attrs)
  end
end
