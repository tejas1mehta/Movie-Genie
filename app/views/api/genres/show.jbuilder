json.genre_movie_ids @genre.genre_movie_joins.map(&:movie_id)
json.id @genre.id
json.title @genre.title