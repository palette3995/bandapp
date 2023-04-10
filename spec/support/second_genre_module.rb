module SecondGenreModule
  def second_genre
    select "その他", from: "user[user_genres_attributes][1][genre_id]"
    fill_in("user[user_genres_attributes][1][other_genre]", with: "シューゲイザー")
  end
end
