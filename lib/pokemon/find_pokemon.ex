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

  @spec filter_pokemon(bitstring) :: struct
  def filter_pokemon(search) do
    pokemons = list_of_pokemon()

    pokemon_url =
      Enum.filter(pokemons, fn pokemon ->
        %{"name" => pokemon_name, "url" => url} = pokemon

        if pokemon_name == search do
          HTTPoison.get(url)
        end
      end)

    [%{"name" => _name, "url" => api_url}] = pokemon_url
    information = info_pokemon(api_url)
    making_struct(information)
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

  defp info_pokemon(api_url) do
    {:ok, response} = HTTPoison.get(api_url)
    Poison.decode!(response.body)
  end

  defp list_of_pokemon() do
    {:ok, response} = HTTPoison.get("https://pokeapi.co/api/v2/pokemon/?limit=1281")
    list_of_pokemon = Poison.decode!(response.body)
    list_of_pokemon["results"]
  end
end
