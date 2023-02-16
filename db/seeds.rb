# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# partの初期データを追加
# Part.create!(id: 1, name: "ボーカル")
# Part.create!(id: 2, name: "ギター")
# Part.create!(id: 3, name: "ベース")
# Part.create!(id: 4, name: "ドラム/パーカッション")
# Part.create!(id: 5, name: "キーボード/ピアノ")
# Part.create!(id: 6, name: "その他")
# Part.create!(id: 7, name: "未選択")

# genreの初期データを追加
# Genre.create!(id: 1, name: "J-POP")
# Genre.create!(id: 2, name: "アニメ")
# Genre.create!(id: 3, name: "邦楽ヒップホップ/R&B/レゲエ")
# Genre.create!(id: 4, name: "邦楽ロック")
# Genre.create!(id: 5, name: "邦楽ダンス/エレクトロニカ")
# Genre.create!(id: 6, name: "ボーカロイド")
# Genre.create!(id: 7, name: "K-POP/ワールド・ミュージック")
# Genre.create!(id: 8, name: "洋楽ポップス")
# Genre.create!(id: 9, name: "洋楽ヒップホップ/R&B/レゲエ")
# Genre.create!(id: 10, name: "洋楽ロック")
# Genre.create!(id: 11, name: "洋楽ダンス/エレクトロニカ")
# Genre.create!(id: 12, name: "歌謡曲/演歌")
# Genre.create!(id: 13, name: "ジャズ")
# Genre.create!(id: 14, name: "クラシック")
# Genre.create!(id: 15, name: "その他")
# Genre.create!(id: 16, name: "未選択")

# 30.times do |n|
#   User.create!(
#     name: "テストユーザー(大阪)#{n+1}",
#     email: "#{n+1}@#{n+1}",
#     password: 111111,
#     prefecture_id: 27,
#     introduction: "よろしくお願いします！",
#     age: n + 18,
#     sex: "男性",
#     original: "オリジナル曲",
#     frequency: "月２〜３日",
#     motivation: "趣味で楽しく",
#     activity_time: "夜",
#     available_day: "日,土"
#   )
# end
#
# 30.times do |n|
#   User.create!(
#     name: "テストユーザー(東京)#{n+1}",
#     email: "#{n+31}@#{n+31}",
#     password: 111111,
#     prefecture_id: 13,
#     introduction: "よろしくお願いします！",
#     age: n + 18,
#     sex: "男性",
#     original: "オリジナル曲",
#     frequency: "月２〜３日",
#     motivation: "趣味で楽しく",
#     activity_time: "夜",
#     available_day: "日,土"
#   )
# end
#
# 30.times do |n|
#   User.create!(
#     name: "テストユーザー(京都)#{n+1}",
#     email: "#{n+61}@#{n+61}",
#     password: 111111,
#     prefecture_id: 26,
#     introduction: "よろしくお願いします！",
#     age: n + 18,
#     sex: "男性",
#     original: "オリジナル曲",
#     frequency: "月２〜３日",
#     motivation: "趣味で楽しく",
#     activity_time: "夜",
#     available_day: "日,土"
#   )
# end
