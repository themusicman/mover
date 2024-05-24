defmodule Mover.EstimatesTest do
  use Mover.DataCase

  alias Mover.Estimates

  describe "estimates" do
    alias Mover.Estimates.Estimate

    import Mover.EstimatesFixtures

    @invalid_attrs %{
      origin: %{zip: nil},
      destination: %{zip: nil},
      distance: nil,
      standard_rate: nil,
      cost_adjustment: nil,
      cost: nil
    }

    test "list_estimates/0 returns all estimates" do
      estimate = estimate_fixture()
      assert Estimates.list_estimates() == [estimate]
    end

    test "get_estimate!/1 returns the estimate with given id" do
      estimate = estimate_fixture()
      assert Estimates.get_estimate!(estimate.id) == estimate
    end

    test "create_estimate/1 with valid data creates a estimate" do
      valid_attrs = %{
        origin: %{zip: "32738"},
        destination: %{zip: "32003"},
        standard_rate: 42,
        cost_adjustment: 120.5
      }

      assert {:ok, %Estimate{} = estimate} = Estimates.create_estimate(valid_attrs)
      assert estimate.origin.zip == "32738"
      assert estimate.destination.zip == "32003"
      assert estimate.standard_rate == 42
      assert estimate.cost_adjustment == 120.5
    end

    test "create_estimate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Estimates.create_estimate(@invalid_attrs)
    end

    test "update_estimate/2 with valid data updates the estimate" do
      estimate = estimate_fixture()

      update_attrs = %{
        origin: %{id: estimate.origin.id, zip: "90210", city: "Somewhere", state: "CA"},
        destination: %{
          id: estimate.destination.id,
          zip: "60611",
          city: "Another Place",
          state: "TN"
        },
        distance: 43,
        standard_rate: 43,
        cost_adjustment: 456.7,
        cost: 43
      }

      assert {:ok, %Estimate{} = estimate} = Estimates.update_estimate(estimate, update_attrs)
      assert estimate.origin.zip == "90210"
      assert estimate.destination.zip == "60611"
      assert estimate.distance == 43
      assert estimate.standard_rate == 43
      assert estimate.cost_adjustment == 456.7
      assert estimate.cost == %Money{amount: 43, currency: :USD}
    end

    test "update_estimate/2 with invalid data returns error changeset" do
      estimate = estimate_fixture()
      assert {:error, %Ecto.Changeset{}} = Estimates.update_estimate(estimate, @invalid_attrs)
      assert estimate == Estimates.get_estimate!(estimate.id)
    end

    test "delete_estimate/1 deletes the estimate" do
      estimate = estimate_fixture()
      assert {:ok, %Estimate{}} = Estimates.delete_estimate(estimate)
      assert_raise Ecto.NoResultsError, fn -> Estimates.get_estimate!(estimate.id) end
    end

    test "change_estimate/1 returns a estimate changeset" do
      estimate = estimate_fixture()
      assert %Ecto.Changeset{} = Estimates.change_estimate(estimate)
    end
  end
end
