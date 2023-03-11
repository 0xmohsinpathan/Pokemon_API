defmodule Pokemon do
  @moduledoc """
  Documentation for `Pokemon`.

  The Pokemon API is a RESTful API that allows developers to access information about Pokemon.

  """

  @spec get(bitstring) :: struct
  
  def get(search) do
    Pokemon.Find.filter_pokemon(search)
  end
end
