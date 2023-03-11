defmodule Pokemon.Find do
  @moduledoc """
  Documentation for `Pokemon.Find`.

  We can find Any Pokemon Information.

  Returns detailed information about a specific Pokemon. Replace "{id or name}" with the ID number or name of the Pokemon you want to look up. For example, to get information about Pikachu, use the following URL:

  https://pokeapi.co/api/v2/pokemon/pikachu
  """
  alias Pokemon.Find

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

  @doc """
   Let Check over code is working with valid input.

  ## Examples

      iex> Pokemon.Find.filter_pokemon("pikachu")
      {:ok, %Pokemon.Find{id: 25, name: "pikachu", hp: 35, attack: 55, defense: 40, special_attack: 50,special_defense: 50, speed: 90, height: 4, weight: 60, types: ["electric"]}}

  """

  @spec filter_pokemon(String.t()) :: {:ok, %Find{}} | {:error, String.t()}
  def filter_pokemon(search) do
    # // TODO clean up search for whitespace trim
    # // TODO: {:ok , struct} path
    search = String.trim(search)

    pokemons = list_of_pokemon()

    if !is_nil(search) and is_valid_pokemon?(pokemons, search) do
      # check wherther search name in list_of_pokemons name
      pokemon_url =
        Enum.filter(pokemons, fn pokemon ->
          %{"name" => pokemon_name, "url" => url} = pokemon

          if pokemon_name == search do
            HTTPoison.get(url)
          end
        end)

      [%{"name" => _name, "url" => api_url}] = pokemon_url
      information = info_pokemon(api_url)
      pokemon_detail = making_struct(information)
      {:ok, pokemon_detail}
    else
      {:error, "Invalid Input"}
    end
  end

  defp is_valid_pokemon?(pokemons, test_pokemon) do
    list_of_name_pokemon =
      Enum.map(pokemons, fn %{"name" => name} ->
        name
      end)

    test_pokemon in list_of_name_pokemon
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

  defp list_of_pokemon do
    {:ok, response} = HTTPoison.get("https://pokeapi.co/api/v2/pokemon/?limit=1281")
    list_of_pokemon = Poison.decode!(response.body)
    list_of_pokemon["results"]
  end
end
