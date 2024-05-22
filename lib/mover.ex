defmodule Mover do
  @moduledoc """
  Mover keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @spec google_api_key() :: String.t()
  def google_api_key() do
    Application.get_env(:mover, :google_api_key)
  end
end
