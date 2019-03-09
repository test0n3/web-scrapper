require_relative "web_api_methods"

# Get information from APIs
characters = get_data("https://swapi.co/api/people/")

films = get_data("https://swapi.co/api/films/")

planets =  get_data("https://swapi.co/api/planets/")

# new
species = get_data("https://swapi.co/api/species/")

# Gather required information from data
names = []

# characters
#
# name    : string
# films   : Array
# gender  : string
# species : string
# id      : integer

characters_modified = characters.map do |value|
  {
    name: value["name"],
    films: value["films"],
    gender: value["gender"],
    species: value["species"],
    id: value["url"]
  }
end

# films
#
# episode_id : integer
# title      : string
# director   : string
# release    : string
# characters : array
# id         : integer
#

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

# planets
#
# name      : string
# residents : array
# id        : integer

planets_modified = planets.map do |value|
  {
    name: value["name"],
    residents: value["residents"],
    id: value["url"]
  }
end

# species
# name : string
# id   : integer

species_modified = species.map do |value|
  {
    name: value["name"],
    id: value["url"]
  }
end
# Attach all the string content about SW characters
#
# Required content: films played by each character

character_final = characters_modified.map do |value|
  films_character = value[:films]
  new_value = films_character.map do |film_id|
                  index = films_modified.index { |film| film[:id] == film_id }
                  "Episode " + films_modified[index][:episode_id].to_s + ": " + films_modified[index][:title]
              end
  
  index_species = species_modified.index { |specie| specie[:id] == value[:species][0] }
  
  # puts value[:species]
  # puts index_species
  # puts species_modified[index_species][:name]

  value[:films] = new_value.sort.join("|")
  value[:species] = index_species != nil ? species_modified[index_species][:name] : "Sin especie"
  value
end

# Attach all the string content about SW films
#
# Required content: characters that appear in each film

films_final = films_modified.map do |value|
  character_film = value[:characters]
  new_value=[]

  new_value[0] = character_film.map do |character_id|
    index = characters_modified.index { |character| character[:id] == character_id }
    characters_modified[index][:name]
  end

  new_value[1] = character_film.map do |character_id|
    index = characters_modified.index { |character| character[:id] == character_id }
    characters_modified[index][:gender]
  end

  value[:characters] = new_value[0].sort.join("|")
  value[:gender_count] = new_value[1].group_by {|e| e}.map{|k, v| "#{k} - #{v.length}"}.join("|")
  value
end

# planets
#
# name      : string
# residents : array
# id        : integer
#
# Attach all the 
planets_final = planets_modified.map do |value|
  character_planet = value[:residents]
  new_value = []
  # capturando nombre personaje
  new_value[0] = character_planet.map do |character_id|
    index = characters_modified.index { |character| character[:id] == character_id }
    characters_modified[index][:name]
  end
# capturando especie personaje
  new_value[1] = character_planet.map do |character_species|
    index = characters_modified.index { |character| character[:species] == character_species }
    index != nil ? characters_modified[index][:species] : "Sin especie"
  end

  value[:residents] = new_value[0].sort.join("|")
  value[:species_count] = new_value[1].group_by {|e| e}.map{|k, v| "#{k} - #{v.length}"}.join("|")
  value
end

#puts character_final[0]

create_file(character_final,["name_character","films","gender","id"],"personajes")
create_file(films_final, ["episode","film_title", "director", "release", "characters_name", "fil_id", "gender_distribution" ], "peliculas")
create_file(planets_final, ["planet_name", "residents", "planet_id"], "planetas")