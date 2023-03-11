defmodule PokemonTest do
  use ExUnit.Case
  alias Pokemon.Find
  doctest Pokemon.Find

  describe "test Pokemon.Find.filter_pokemon/1" do
    test "test with valid input" do
      assert Find.filter_pokemon("ditto") ==
               {:ok,
                %Find{
                  id: 132,
                  name: "ditto",
                  hp: 48,
                  attack: 48,
                  defense: 48,
                  special_attack: 48,
                  special_defense: 48,
                  speed: 48,
                  height: 3,
                  weight: 40,
                  types: ["normal"]
                }}
    end

    test "test with wrong spelling" do
      assert Find.filter_pokemon("ditt") == {:error, "error occured"}
    end

    test "test with empty string" do
      assert Find.filter_pokemon("") == {:error, "error occured"}
    end
  end
end
