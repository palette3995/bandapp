levels = %W[未経験 初心者 中級者 上級者]
frequencies = %W[月１日以下 月２〜３日 週１〜２日 週３日以上]
days = %W[平日 土日 不定 いつでも]
times = %W[午前 午後 不定 いつでも]
sexes = %W[男性 女性]
motivations = %W[趣味で楽しく プロを目指す 決めていない]
originals = %W[既存曲のコピー オリジナル曲 決めていない]
composes = [true, false]
ages = %W[20代まで 30代 40代 気にしない]

# ユーザー初期データ作成
30.times do |n|
  User.create!(
    name: "テストユーザー(大阪)#{n + 1}",
    email: "#{n + 1}@#{n + 1}",
    password: 111_111,
    prefecture_id: 27,
    introduction: "よろしくお願いします！",
    age: n + 18,
    sex: sexes.sample,
    original: originals.sample,
    frequency: frequencies.sample,
    motivation: motivations.sample,
    activity_time: times.sample,
    available_day: days.sample,
    compose: composes.sample
  )
end

30.times do |n|
  User.create!(
    name: "テストユーザー(東京)#{n + 1}",
    email: "#{n + 31}@#{n + 31}",
    password: 111_111,
    prefecture_id: 13,
    introduction: "よろしくお願いします！",
    age: n + 18,
    sex: sexes.sample,
    original: originals.sample,
    frequency: frequencies.sample,
    motivation: motivations.sample,
    activity_time: times.sample,
    available_day: days.sample,
    compose: composes.sample
  )
end

# バンド初期データ作成
readers = User.first(30)
members = User.last(30)
30.times do |n|
  band = Band.create(
    name: "テストバンド#{n}",
    introduction: "メンバー募集中！",
    prefecture_id: 27,
    original: originals.sample,
    frequency: frequencies.sample,
    motivation: motivations.sample,
    activity_time: times.sample,
    available_day: days.sample
  )
  band.band_members.create(user_id: readers[n].id, part_id: rand(1..6), role: "リーダー")
  band.band_members.create(user_id: members[n].id, part_id: rand(1..6), role: "メンバー")
end

guest = User.create!(name: "ゲストユーザー", email: "guest@example.com", password: SecureRandom.urlsafe_base64, prefecture_id: 27, introduction: "よろしくお願いします！", age: 20, sex: "男性", original: "オリジナル曲", frequency: "月２〜３日", motivation: "趣味で楽しく", activity_time: "午後", available_day: "土日")

# ゲストユーザーのバンドデータ作成
band_a = Band.create(name: "ゲストバンドA", introduction: "みんなでわいわい楽しくやってます。", prefecture_id: 27, frequency: "月２〜３日", activity_time: "午後", available_day: "土日", motivation: "趣味で楽しく", original: "既存曲のコピー")
band_b = Band.create(name: "ゲストバンドB", introduction: "真剣に音楽で食べていきたい方、加入募集してます。", prefecture_id: 27, frequency: "月２〜３日", activity_time: "いつでも", available_day: "いつでも", motivation: "プロを目指す", original: "オリジナル曲")

band_a.band_members.create(user_id: guest.id, part_id: 1, role: "リーダー")
band_a.band_members.create(user_id: 28, part_id: 2, role: "メンバー")
band_b.band_members.create(user_id: guest.id, part_id: 1, role: "メンバー")
band_b.band_members.create(user_id: 25, part_id: 2, role: "リーダー")
band_b.band_members.create(user_id: 35, part_id: 3, role: "メンバー")

band_a.chats.create(user_id: band_a.band_members[1].user_id, message: "こんにちは！")
band_b.chats.create(user_id: band_b.band_members[1].user_id, message: "あとはドラムほしいですね。")
band_b.chats.create(user_id: band_b.band_members[2].user_id, message: "私いい人探しときます！")

# favoritesデータ作成
2.times do |n|
  guest.favorites.create(favorited_user_id: n + 1)
  guest.favorites.create(band_id: n + 5)
  Favorite.create(user_id: n + 7, favorited_user_id: guest.id)
end

2.times do |n|
  Favorite.create(user_id: n + 15, band_id: band_a.id)
end

# scouts初期データ作成
2.times do |n|
  guest.scouts.create(part_id: 1, scouted_user_id: n + 1, scouted_part_id: rand(1..6))
  guest.scouts.create(part_id: 1, scouted_user_id: Band.find(n + 5).band_members.find_by(role: "リーダー").user_id, scouted_band_id: n + 5)
  guest.scouts.create(band_id: band_a.id, scouted_user_id: n + 30, scouted_part_id: rand(1..6))
  guest.scouts.create(band_id: band_a.id, scouted_user_id: Band.find(n + 10).band_members.find_by(role: "リーダー").user_id, scouted_band_id: n + 10)
  Scout.create(scouted_user_id: guest.id, part_id: rand(1..6), user_id: n + 40, scouted_part_id: 1)
  Scout.create(scouted_user_id: guest.id, part_id: rand(1..6), user_id: n + 50, scouted_band_id: band_a.id)
  Scout.create(scouted_user_id: guest.id, band_id: n + 15, user_id: Band.find(n + 15).band_members.find_by(role: "リーダー").user_id, scouted_part_id: 1)
  Scout.create(scouted_user_id: guest.id, band_id: n + 25, user_id: Band.find(n + 25).band_members.find_by(role: "リーダー").user_id, scouted_band_id: band_a.id)
end

# recruit_members初期データ作成 ジャンル設定
Band.includes(:band_genres).limit(20).each do |band|
  band.recruit_members.create!(part_id: rand(1..6), level: levels.sample, age: ages.sample, sex: sexes.sample)
  band.band_genres[0].update(genre_id: rand(1..15))
  band.update!(
    number_of_member: band.band_members.count,
    maximum_age: band.band_members.joins(:user).maximum(:age),
    minimum_age: band.band_members.joins(:user).minimum(:age),
    average_age: band.band_members.joins(:user).average(:age),
    men: band.band_members.joins(:user).where(user: { sex: "男性" }).count,
    women: band.band_members.joins(:user).where(user: { sex: "女性" }).count
  )
end

# パート、ジャンルの設定
User.includes(:user_parts, :user_genres).limit(30).each do |user|
  user.user_parts.each do |part|
    part.update!(part_id: rand(1..6), level: levels.sample)
  end

  user.user_genres.each do |genre|
    genre.update!(genre_id: rand(1..15))
  end
end

guest.user_parts.each do |part|
  part.update!(part_id: rand(1..6), level: levels.sample)
end

guest.user_genres.each do |genre|
  genre.update!(genre_id: rand(1..15))
end
