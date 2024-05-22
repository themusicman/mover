defmodule Mover.Estimates.Estimate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "estimates" do
    field :origin_zip, :string
    field :destination_zip, :string

    # cache the distance
    field :distance, :integer

    # for historical reporting
    field :standard_rate, :integer
    field :cost_adjustment, :float

    field :cost, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(estimate, attrs) do
    estimate
    |> cast(attrs, [
      :origin_zip,
      :destination_zip,
      :distance,
      :standard_rate,
      :cost_adjustment,
      :cost
    ])
    |> validate_required([:origin_zip, :destination_zip, :standard_rate, :cost_adjustment])
  end
end
