defmodule Mover.DistanceTest do
  use Mover.DataCase
  use Mimic.DSL

  describe "calculate/2" do
    test "geocodes an origin and destination zip code and calculates the distances between them" do
      origin_url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=#{32003}&key=#{Mover.google_api_key()}"

      expect(
        Req.get(^origin_url),
        do: origin_response()
      )

      destination_url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=#{32738}&key=#{Mover.google_api_key()}"

      expect(
        Req.get(^destination_url),
        do: destination_response()
      )

      distance_url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=#{32738}&origins=#{32003}&key=#{Mover.google_api_key()}"

      expect(
        Req.get(^distance_url),
        do: distance_response()
      )

      assert %Mover.Distance{
               origin: %Mover.Estimates.Location{
                 id: nil,
                 city: "Orange Park",
                 state: "Florida",
                 zip: "32003"
               },
               destination: %Mover.Estimates.Location{
                 id: nil,
                 city: "Deltona",
                 state: "Florida",
                 zip: "32738"
               },
               distance: 117
             } = Mover.Distance.calculate(32003, 32738)
    end

    test "gracefully handles an error geocoding the origin" do
      origin_url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=#{32003}&key=#{Mover.google_api_key()}"

      expect(
        Req.get(^origin_url),
        do: {:error, :oops}
      )

      assert {:error, "Could not geocode :origin '32003' zip."} =
               Mover.Distance.calculate(32003, 32738)
    end

    test "gracefully handles an error geocoding the destination" do
      origin_url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=#{32003}&key=#{Mover.google_api_key()}"

      expect(
        Req.get(^origin_url),
        do: origin_response()
      )

      destination_url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=#{32738}&key=#{Mover.google_api_key()}"

      expect(
        Req.get(^destination_url),
        do: {:error, :oops}
      )

      assert {:error, "Could not geocode :destination '32738' zip."} =
               Mover.Distance.calculate(32003, 32738)
    end

    test "gracefully handles an error calculating the driving distance" do
      origin_url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=#{32003}&key=#{Mover.google_api_key()}"

      expect(
        Req.get(^origin_url),
        do: origin_response()
      )

      destination_url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=#{32738}&key=#{Mover.google_api_key()}"

      expect(
        Req.get(^destination_url),
        do: destination_response()
      )

      distance_url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=#{32738}&origins=#{32003}&key=#{Mover.google_api_key()}"

      expect(
        Req.get(^distance_url),
        do: {:error, :oops}
      )

      assert {:error, "Could not calculate the distance"} = Mover.Distance.calculate(32003, 32738)
    end
  end

  defp destination_response() do
    {:ok,
     %Req.Response{
       status: 200,
       headers: %{
         "access-control-allow-origin" => ["*"],
         "alt-svc" => ["h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000"],
         "cache-control" => ["no-cache, must-revalidate"],
         "content-type" => ["application/json; charset=UTF-8"],
         "date" => ["Thu, 23 May 2024 11:57:06 GMT"],
         "expires" => ["Fri, 01 Jan 1990 00:00:00 GMT"],
         "pragma" => ["no-cache"],
         "server" => ["mafe"],
         "server-timing" => ["gfet4t7; dur=44"],
         "vary" => ["Accept-Language"],
         "x-frame-options" => ["SAMEORIGIN"],
         "x-xss-protection" => ["0"]
       },
       body: %{
         "results" => [
           %{
             "address_components" => [
               %{
                 "long_name" => "32738",
                 "short_name" => "32738",
                 "types" => ["postal_code"]
               },
               %{
                 "long_name" => "Deltona",
                 "short_name" => "Deltona",
                 "types" => ["locality", "political"]
               },
               %{
                 "long_name" => "Volusia County",
                 "short_name" => "Volusia County",
                 "types" => ["administrative_area_level_2", "political"]
               },
               %{
                 "long_name" => "Florida",
                 "short_name" => "FL",
                 "types" => ["administrative_area_level_1", "political"]
               },
               %{
                 "long_name" => "United States",
                 "short_name" => "US",
                 "types" => ["country", "political"]
               }
             ],
             "formatted_address" => "Deltona, FL 32738, USA",
             "geometry" => %{
               "bounds" => %{
                 "northeast" => %{"lat" => 28.976425, "lng" => -81.15110700000001},
                 "southwest" => %{"lat" => 28.843839, "lng" => -81.2405239}
               },
               "location" => %{"lat" => 28.9075315, "lng" => -81.1747498},
               "location_type" => "APPROXIMATE",
               "viewport" => %{
                 "northeast" => %{"lat" => 28.976425, "lng" => -81.15110700000001},
                 "southwest" => %{"lat" => 28.843839, "lng" => -81.2405239}
               }
             },
             "place_id" => "ChIJs8O8ZLcX54gRhRhk6qJivH0",
             "types" => ["postal_code"]
           }
         ],
         "status" => "OK"
       },
       trailers: %{},
       private: %{}
     }}
  end

  defp origin_response() do
    {:ok,
     %Req.Response{
       status: 200,
       headers: %{
         "access-control-allow-origin" => ["*"],
         "alt-svc" => ["h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000"],
         "cache-control" => ["no-cache, must-revalidate"],
         "content-type" => ["application/json; charset=UTF-8"],
         "date" => ["Thu, 23 May 2024 11:57:06 GMT"],
         "expires" => ["Fri, 01 Jan 1990 00:00:00 GMT"],
         "pragma" => ["no-cache"],
         "server" => ["mafe"],
         "server-timing" => ["gfet4t7; dur=98"],
         "vary" => ["Accept-Language"],
         "x-frame-options" => ["SAMEORIGIN"],
         "x-xss-protection" => ["0"]
       },
       body: %{
         "results" => [
           %{
             "address_components" => [
               %{
                 "long_name" => "32003",
                 "short_name" => "32003",
                 "types" => ["postal_code"]
               },
               %{
                 "long_name" => "Orange Park",
                 "short_name" => "Orange Park",
                 "types" => ["locality", "political"]
               },
               %{
                 "long_name" => "Clay County",
                 "short_name" => "Clay County",
                 "types" => ["administrative_area_level_2", "political"]
               },
               %{
                 "long_name" => "Florida",
                 "short_name" => "FL",
                 "types" => ["administrative_area_level_1", "political"]
               },
               %{
                 "long_name" => "United States",
                 "short_name" => "US",
                 "types" => ["country", "political"]
               }
             ],
             "formatted_address" => "Orange Park, FL 32003, USA",
             "geometry" => %{
               "bounds" => %{
                 "northeast" => %{"lat" => 30.151533, "lng" => -81.6799728},
                 "southwest" => %{"lat" => 30.041494, "lng" => -81.756782}
               },
               "location" => %{"lat" => 30.104973, "lng" => -81.71305219999999},
               "location_type" => "APPROXIMATE",
               "viewport" => %{
                 "northeast" => %{"lat" => 30.151533, "lng" => -81.6799728},
                 "southwest" => %{"lat" => 30.041494, "lng" => -81.756782}
               }
             },
             "place_id" => "ChIJyzi-QTzF5YgRPyNIq4LoIaY",
             "postcode_localities" => ["Fleming Island", "Hibernia"],
             "types" => ["postal_code"]
           }
         ],
         "status" => "OK"
       },
       trailers: %{},
       private: %{}
     }}
  end

  defp distance_response() do
    {:ok,
     %Req.Response{
       status: 200,
       headers: %{
         "alt-svc" => ["h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000"],
         "cache-control" => ["no-cache, must-revalidate"],
         "content-type" => ["application/json; charset=UTF-8"],
         "date" => ["Thu, 23 May 2024 11:57:07 GMT"],
         "expires" => ["Fri, 01 Jan 1990 00:00:00 GMT"],
         "pragma" => ["no-cache"],
         "server" => ["mafe"],
         "server-timing" => ["gfet4t7; dur=81"],
         "vary" => ["Accept-Language"],
         "x-frame-options" => ["SAMEORIGIN"],
         "x-xss-protection" => ["0"]
       },
       body: %{
         "destination_addresses" => ["Deltona, FL 32738, USA"],
         "origin_addresses" => ["Orange Park, FL 32003, USA"],
         "rows" => [
           %{
             "elements" => [
               %{
                 "distance" => %{"text" => "189 km", "value" => 188_735},
                 "duration" => %{"text" => "1 hour 51 mins", "value" => 6641},
                 "status" => "OK"
               }
             ]
           }
         ],
         "status" => "OK"
       },
       trailers: %{},
       private: %{}
     }}
  end
end
