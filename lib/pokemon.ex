defmodule Pokemon do
  @moduledoc """
  Documentation for `Pokemon`.

  The Pokemon API is a RESTful API that allows developers to access information about Pokemon.

  Returns detailed information about a specific Pokemon. Replace "{id or name}" with the ID number or name of the Pokemon you want to look up. For example, to get information about Pikachu, use the following URL:

  https://pokeapi.co/api/v2/pokemon/pikachu

  """

  @spec get(bitstring) :: struct
  def get(search) do
    Pokemon.Find.filter_pokemon(search)
  end
end
