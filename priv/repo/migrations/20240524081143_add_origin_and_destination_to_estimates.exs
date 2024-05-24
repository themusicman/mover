defmodule Mover.Repo.Migrations.AddOriginAndDestinationToEstimates do
  use Ecto.Migration

  def change do
    alter table(:estimates) do
      add :origin, :map
      add :destination, :map
      remove :origin_zip
      remove :destination_zip
    end
  end
end
