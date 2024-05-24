defmodule Mover.Estimates.Location do
  @moduledoc """
  A physical location
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Mover.Validators, only: [validate_zip: 2]
  alias Mover.Estimates.Location

  @typedoc """
  Estimate Location
  """
  @type t :: %__MODULE__{
          id: pos_integer(),
          city: String.t(),
          state: String.t(),
          zip: String.t()
        }

  embedded_schema do
    field :city, :string
    field :state, :string
    field :zip, :string
  end

  @doc false
  def create_changeset(%Location{} = location, attrs \\ %{}) do
    location
    |> cast(attrs, [:zip])
    |> validate_required([:zip])
    |> validate_zip(:zip)
  end

  @doc false
  def changeset(%Location{} = location, attrs \\ %{}) do
    location
    |> cast(attrs, [:city, :state, :zip])
    |> validate_required([:city, :state, :zip])
    |> validate_zip(:zip)
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(nil), do: ""

    def to_iodata(location) do
      Enum.reduce(
        [{:city, location.city}, {:state, location.state}, {:zip, location.zip}],
        "",
        fn {type, value}, acc ->
          if Flamel.present?(value), do: append_component(type, acc, value), else: acc
        end
      )
      |> String.trim()
    end

    defp append_component(:city, acc, value), do: acc <> value
    # fix issue where if there is no city we will have an un-needed comma
    defp append_component(:state, acc, value), do: acc <> ", " <> value
    defp append_component(:zip, acc, value), do: acc <> " " <> value
    defp append_component(_type, acc, _value), do: acc
  end
end
