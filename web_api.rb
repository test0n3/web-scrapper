require_relative "web_api_methods"

#Obtener informacion de APIS
characters = get_data("https://swapi.co/api/people/")

films = get_data("https://swapi.co/api/films/")

planets =  get_data("https://swapi.co/api/planets/")

#Modifica la data
names = []
characters_modified = characters.map do |value|
    {
        name: value["name"],
        films: value["films"],
        gender: value["gender"],
        id: value["url"]
    }
end

films_modified = films.map do |value|
    {
        episode_id: value["episode_id"],
        title: value["title"],
        director: value["director"],
        release: value["release_date"],
        characters: value["characters"],
        id: value["url"]
    }
end

planets_modified = planets.map do |value|
    {
        name: value["name"],
        residents: value["residents"],
        id: value["url"]
    }
end

character_final = characters_modified.map do |value|
    films_character = value[:films]
    new_value = films_character.map do |film_id|
                    index = 0
                    films_modified.each.with_index do |film, index_film|
                        if film[:id] == film_id
                            index = index_film
                            break
                        end
                    end
                    "Episode " + films_modified[index][:episode_id].to_s + ": " + films_modified[index][:title]
                end
    value[:films] = new_value.sort.join("|")
    value
end

#puts character_final[0]

create_file(character_final,["name_character","films","gender","id"],"personajes")