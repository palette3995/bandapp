module ThirdGenreModule
  def third_genre
    select "その他", from: "user[user_genres_attributes][2][genre_id]"
    fill_in("user[user_genres_attributes][2][other_genre]", with: "メタル")
  end
end
