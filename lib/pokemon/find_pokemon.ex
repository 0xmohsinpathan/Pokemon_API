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

  defp making_struct(abilities) do
    id = abilities["id"]

    [%{"name" => name} | _tail] = abilities["forms"]

    [
      %{"base_stat" => hp},
      %{"base_stat" => attack},
      %{"base_stat" => defense},
      %{"base_stat" => specialattack},
      %{"base_stat" => specialdefence},
      %{"base_stat" => speed}
    ] = abilities["stats"]

    weight = abilities["weight"]
    height = abilities["height"]

    list_of_types = abilities["types"]
    types = Enum.map(list_of_types, fn %{"type" => %{"name" => type}} -> type end)

    map = %{
      types: types,
      weight: weight,
      height: height,
      name: name,
      speed: speed,
      special_defense: specialdefence,
      special_attack: specialattack,
      defense: defense,
      attack: attack,
      hp: hp,
      id: id
    }

    Kernel.struct(Pokemon.Find, map)
  end

  defp list_of_pokemon() do
    {:ok, response} = HTTPoison.get("https://pokeapi.co/api/v2/pokemon/?limit=1281")
    list_of_pokemon = Poison.decode!(response.body)
    list_of_pokemon["results"]
  end
end
