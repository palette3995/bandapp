module FirstGenreModule
  def first_genre
    select "その他", from: "user[user_genres_attributes][0][genre_id]"
    fill_in("user[user_genres_attributes][0][other_genre]", with: "テクノポップ")
  end
end
