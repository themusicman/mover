defmodule Mover.Estimates.Location do
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
          if Flamel.present?(value) do
            case type do
              :city -> acc <> value
              # TODO: fix the issue if the city is missing but the state is not
              :state -> acc <> ", " <> value
              :zip -> acc <> " " <> value
            end
          else
            acc
          end
        end
      )
      |> String.trim()
    end
  end
end
