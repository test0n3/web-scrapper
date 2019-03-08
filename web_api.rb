require_relative "web_api_methods"

characters = get_data("https://swapi.co/api/people/")

films = get_data("https://swapi.co/api/films/")

planets =  get_data("https://swapi.co/api/planets/")

names = []
new_characters = characters.map do |value|
    {
        name: value["name"],
        films: value["films"].sort,
        gender: value["gender"],
        id: value["url"]
    }
end

new_films = films.map do |value|
    {
        episode_id: value["episode_id"],
        title: value["title"],
        director: value["director"],
        release: value["release_date"],
        characters: value["characters"].sort,
        id: value["url"]
    }
end

new_planets = planets.map do |value|
    {
        name: value["name"],
        residents: value["residents"].sort,
        id: value["url"]
    }
end

# headers_characters = ["name", "films", "gender", "url"]
# create_file(new_characters.map{ |val| val.values }, headers_characters, "characters")