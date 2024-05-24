defmodule Mover.ValidatorsTest do
  use Mover.DataCase
  doctest Mover.Validators

  @valid_zips [
    # Cambridge, MA
    "02139",
    # New York, NY
    "10001",
    # Atlanta, GA
    "30301",
    # Chicago, IL
    "60601",
    # San Francisco, CA
    "94105",
    # Austin, TX
    "73301",
    # Seattle, WA
    "98101",
    # Philadelphia, PA
    "19104",
    # Washington, DC
    "20001",
    # Miami, FL
    "33101",
    # Phoenix, AZ
    "85001",
    # Pittsburgh, PA
    "15201",
    # Columbus, OH
    "43201",
    # Minneapolis, MN
    "55401",
    # Denver, CO
    "80201",
    # Ann Arbor, MI
    "48104",
    # Nashville, TN
    "37201",
    # Honolulu, HI
    "96801",
    # Madison, WI
    "53703",
    # Chicago, IL
    "60614",
    # Dallas, TX
    "75201",
    # Raleigh, NC
    "27601",
    # Oklahoma City, OK
    "73101",
    # Indianapolis, IN
    "46201",
    # Baton Rouge, LA
    "70801",
    # Chattanooga, TN
    "37401",
    # Salt Lake City, UT
    "84101",
    # Des Moines, IA
    "50301",
    # Portland, ME
    "04101",
    # Boston, MA
    "02108",
    # Minneapolis, MN
    "55415",
    # Denver, CO
    "80203",
    # Portland, OR
    "97201",
    # Las Vegas, NV
    "89101",
    # Cary, NC
    "27511",
    # Columbia, SC
    "29201",
    # Salt Lake City, UT
    "84102",
    # Des Moines, IA
    "50309",
    # Indianapolis, IN
    "46225",
    # Boston, MA
    "02110",
    # Minneapolis, MN
    "55402",
    # Denver, CO
    "80202",
    # Portland, OR
    "97204",
    # Las Vegas, NV
    "89109",
    # Cary, NC
    "27518",
    # Columbia, SC
    "29202",
    # Salt Lake City, UT
    "84103",
    # New York, NY
    "10001-1234",
    # San Francisco, CA
    "94105-6789",
    # Chicago, IL
    "60601-4321",
    # Austin, TX
    "73301-9876"
  ]

  @invalid_zips [
    # Invalid: letters
    "ABCDE",
    # Invalid: too short
    "123",
    # Invalid: too long
    "123456",
    # Invalid: incorrect format
    "12-345",
    # Invalid: letters
    "1A345",
    # Invalid: special character
    "1234!",
    # Invalid: too short
    "1234",
    # Invalid: too long
    "1234567",
    # Invalid: letters
    "1234A",
    # Invalid: letters
    "ABCDE-1234",
    # Invalid: incorrect format
    "123-1234",
    # Invalid: too short
    "1234-567",
    # Invalid: too long
    "12345-67890",
    # Invalid: letters
    "12345-678A",
    # Invalid: space
    "12 345",
    # Invalid: space
    "12345 6789",
    # Invalid: letters
    "1234A-5678",
    # Invalid: letters
    "ABCDE-6789",
    # Invalid: special character
    "12345-678!",
    # Invalid: too short
    "12345-678",
    # Invalid: too long
    "12345-67890",
    # Invalid: incorrect format
    "12-345-6789",
    # Invalid: incorrect format
    "123-456789",
    # Invalid: incorrect format
    "1234-56789",
    # Invalid: too long
    "1234567890",
    # Invalid: letters
    "ABCDE12345",
    # Invalid: special character
    "12345_6789",
    # Invalid: special character
    "12345.6789",
    # Invalid: special character
    "12345/6789",
    # Invalid: special character
    "12345*6789",
    # Invalid: too long
    "123456789",
    # Invalid: special character
    "12!3456789",
    # Invalid: too long
    "12345-67890",
    # Invalid: letters and too short
    "ABCDE-1",
    # Invalid: space
    "12345 678",
    # Invalid: too long
    "12345678",
    # Invalid: space
    "12 3456789",
    # Invalid: letters
    "12345-ABCD",
    # Invalid: special character
    "12345!6789",
    # Invalid: space
    "1 3456789",
    # Invalid: special character
    "12345@6789",
    # Invalid: special character
    "12*456789",
    # Invalid: special character
    "12.456789",
    # Invalid: special character
    "12/456789",
    # Invalid: incorrect format
    "12-456789",
    # Invalid: incorrect format
    "1234-5678",
    # Invalid: letters
    "12345-67A9",
    # Invalid: too short
    "12-45678",
    # Invalid: incorrect format
    "123-56789"
  ]

  describe "valid_zip?/1" do
    test "returns true if the zip code is valid" do
      Enum.each(@valid_zips, fn zip ->
        assert Mover.Validators.valid_zip?(zip)
      end)
    end

    test "returns false if the zip code is invalid" do
      Enum.each(@invalid_zips, fn zip ->
        assert Mover.Validators.valid_zip?(zip) == false
      end)
    end
  end
end
