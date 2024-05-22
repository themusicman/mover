defmodule Mover.Repo do
  use Ecto.Repo,
    otp_app: :mover,
    adapter: Ecto.Adapters.SQLite3
end
