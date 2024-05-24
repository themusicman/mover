defmodule Mover.Repo.Migrations.AddStatusToEstimate do
  use Ecto.Migration

  def change do
    alter table(:estimates) do
      add :status, :string
    end
  end
end
