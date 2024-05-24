defmodule Mover.Estimates.Estimate do
  @moduledoc """
  The represents an estimate for the cost of a move of a given size for a
  person that is moving between two different zip codes.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Mover.Estimates.Location

  @typedoc """
  Estimate
  """
  @type t :: %__MODULE__{
          id: pos_integer(),
          origin: Location.t(),
          destination: Location.t(),
          distance: pos_integer(),
          standard_rate: float(),
          cost_adjustment: float(),
          cost: pos_integer(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "estimates" do
    field :status, Ecto.Enum, values: [:calculating, :failed, :complete], default: :calculating

    embeds_one :origin, Location, on_replace: :update
    embeds_one :destination, Location, on_replace: :update

    # cache the distance in miles
    field :distance, :integer

    # for historical reporting
    field :standard_rate, :float
    field :cost_adjustment, :float

    field :cost, Money.Ecto.Amount.Type

    timestamps(type: :utc_datetime)
  end

  @doc false
  def create_changeset(estimate, attrs) do
    estimate
    |> cast(attrs, [
      :status,
      :standard_rate,
      :cost_adjustment
    ])
    |> validate_required([
      :standard_rate,
      :cost_adjustment,
      :status
    ])
    |> cast_embed(:origin, required: true, with: &Location.create_changeset/2)
    |> cast_embed(:destination, required: true, with: &Location.create_changeset/2)
  end

  @doc false
  def failed_changeset(estimate, attrs) do
    estimate
    |> cast(attrs, [
      :status,
      :standard_rate,
      :cost_adjustment
    ])
    |> validate_required([
      :standard_rate,
      :cost_adjustment,
      :status
    ])
  end

  @doc false
  def changeset(estimate, attrs) do
    estimate
    |> cast(attrs, [
      :status,
      :distance,
      :standard_rate,
      :cost_adjustment,
      :cost
    ])
    |> validate_required([
      :standard_rate,
      :cost_adjustment,
      :status,
      :distance,
      :cost
    ])
    |> cast_embed(:origin, required: true, with: &Location.changeset/2)
    |> cast_embed(:destination, required: true, with: &Location.changeset/2)
  end
end
