defmodule Mover.Distance do
  @moduledoc """
  Calculates the driving distance between 2 zip codes
  """
  alias Flamel.Context
  alias Mover.Estimates.Location

  @typedoc """
  Distance
  """
  @type t :: %__MODULE__{
          origin: Location.t(),
          destination: Location.t(),
          distance: pos_integer()
        }

  defstruct origin: nil,
            destination: nil,
            distance: nil

  @spec calculate(String.t(), String.t()) :: Distance.t()
  def calculate(origin_zip, destination_zip) do
    %Context{}
    |> geocode_zip(:origin, origin_zip)
    |> geocode_zip(:destination, destination_zip)
    |> calculate_distance()
    |> then(fn
      %Context{halt?: true, reason: reason} ->
        {:error, reason}

      %Context{} = context ->
        %Mover.Distance{
          origin: context.assigns.origin,
          destination: context.assigns.destination,
          distance: context.assigns.distance
        }
    end)
  end

  defp geocode_zip(%Context{halt?: true} = context, _type, _zip), do: context

  defp geocode_zip(%Context{} = context, type, zip) do
    "https://maps.googleapis.com/maps/api/geocode/json?address=#{zip}&key=#{Mover.google_api_key()}"
    |> Req.get()
    |> handle_geocode_response(context, type, zip)
  end

  defp handle_geocode_response(
         {:ok, %Req.Response{body: %{"results" => [address | _]}}},
         context,
         type,
         _zip
       ) do
    location =
      Enum.reduce(address["address_components"], %Location{}, &handle_component_type(&1, &2))

    Context.assign(context, type, location)
  end

  defp handle_geocode_response(_response, context, type, zip) do
    Context.halt!(context, "Could not geocode #{inspect(type)} '#{inspect(zip)}' zip.")
  end

  defp handle_component_type(%{"types" => ["postal_code"], "long_name" => long_name}, acc),
    do: %{acc | zip: long_name}

  defp handle_component_type(
         %{"types" => ["locality", "political"], "long_name" => long_name},
         acc
       ),
       do: %{acc | city: long_name}

  defp handle_component_type(
         %{"types" => ["administrative_area_level_1", "political"], "long_name" => long_name},
         acc
       ),
       do: %{acc | state: long_name}

  defp handle_component_type(_component, acc), do: acc

  defp calculate_distance(%Context{halt?: true} = context), do: context

  defp calculate_distance(%Context{} = context) do
    Req.get(
      "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=#{context.assigns.destination.zip}&origins=#{context.assigns.origin.zip}&key=#{Mover.google_api_key()}"
    )
    |> case do
      {:ok,
       %Req.Response{
         body: %{
           "rows" => [
             %{
               "elements" => [
                 %{
                   "distance" => %{"text" => _, "value" => distance_in_meters}
                 }
               ]
             }
           ]
         }
       }} ->
        distance_in_meters
        |> convert_meters_to_miles()
        |> Flamel.to_integer()
        |> then(fn distance_in_miles ->
          Context.assign(context, :distance, distance_in_miles)
        end)

      _ ->
        Context.halt!(context, "Could not calculate the distance")
    end
  end

  defp convert_meters_to_miles(meters) do
    meters * 0.00062137
  end
end
