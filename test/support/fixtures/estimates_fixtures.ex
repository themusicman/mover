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
        cost: 42,
        cost_adjustment: 120.5,
        destination_zip: "some destination_zip",
        distance: 42,
        origin_zip: "some origin_zip",
        standard_rate: 42
      })
      |> Mover.Estimates.create_estimate()

    estimate
  end
end
