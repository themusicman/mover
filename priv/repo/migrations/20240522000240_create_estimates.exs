defmodule Mover.Repo.Migrations.CreateEstimates do
  use Ecto.Migration

  def change do
    create table(:estimates) do
      add :origin_zip, :string
      add :destination_zip, :string
      add :distance, :integer
      add :standard_rate, :float
      add :cost_adjustment, :float
      add :cost, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
