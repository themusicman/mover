defmodule Mover.EstimatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mover.Estimates` context.
  """

  @doc """
  Generate a estimate.
  """
  def estimate_fixture(attrs \\ %{}) do
    {:ok, estimate} =
      attrs
      |> Enum.into(%{
        cost_adjustment: 120.5,
        destination: %{zip: "32003"},
        origin: %{zip: "32738"},
        standard_rate: 42
      })
      |> Mover.Estimates.create_estimate()

    estimate
  end
end
