defmodule Mover.Validators do
  @moduledoc """
  A set of validations for Ecto
  """
  import Ecto.Changeset

  @spec validate_zip(Ecto.Changeset.t(), atom(), Keyword.t()) :: Ecto.Changeset.t()
  def validate_zip(changeset, field, opts \\ []) do
    validate_change(changeset, field, opts, fn _, value ->
      if valid_zip?(value),
        do: [],
        else: [{field, "is an invalid zip code"}]
    end)
  end

  @zip_code_regex ~r/^\d{5}(-\d{4})?$/

  @doc """
  Validates a zip code

  ## Examples

      iex> Mover.Validators.valid_zip?("12345")
      true

      iex> Mover.Validators.valid_zip?("123")
      false
  """
  @spec valid_zip?(String.t()) :: boolean()
  def valid_zip?(value) do
    Regex.match?(@zip_code_regex, value)
  end
end
