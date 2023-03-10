defmodule Pokemon.Find do
  defstruct [
    :id,
    :name,
    :hp,
    :attack,
    :defense,
    :special_attack,
    :special_defense,
    :speed,
    :height,
    :weight,
    :types
  ]

  def filter(search) do
  end

  defp list_of_pokemon() do
    {:ok, response} = HTTPoison.get("https://pokeapi.co/api/v2/pokemon/?limit=1281")
    list_of_pokemon = Poison.decode!(response.body)
    list_of_pokemon["results"]
  end
end
