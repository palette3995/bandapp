30.times do |n|
  User.create!(
    name: "テストユーザー(大阪)#{n+1}",
    email: "#{n+1}@#{n+1}",
    password: 111111,
    prefecture_id: 27,
    introduction: "よろしくお願いします！",
    age: n + 18,
    sex: "男性",
    original: "オリジナル曲",
    frequency: "月２〜３日",
    motivation: "趣味で楽しく",
    activity_time: "夜",
    available_day: "日,土"
  )
end

30.times do |n|
  User.create!(
    name: "テストユーザー(東京)#{n+1}",
    email: "#{n+31}@#{n+31}",
    password: 111111,
    prefecture_id: 13,
    introduction: "よろしくお願いします！",
    age: n + 18,
    sex: "男性",
    original: "オリジナル曲",
    frequency: "月２〜３日",
    motivation: "趣味で楽しく",
    activity_time: "夜",
    available_day: "日,土"
  )
end

30.times do |n|
  User.create!(
    name: "テストユーザー(京都)#{n+1}",
    email: "#{n+61}@#{n+61}",
    password: 111111,
    prefecture_id: 26,
    introduction: "よろしくお願いします！",
    age: n + 18,
    sex: "男性",
    original: "オリジナル曲",
    frequency: "月２〜３日",
    motivation: "趣味で楽しく",
    activity_time: "夜",
    available_day: "日,土"
  )
end

readers = User.first(40)
members = User.last(40)
40.times do |n|
  band = Band.create(
  name: "テストバンド#{n}",
  introduction: "メンバー募集中！",
  prefecture_id: 27,
  frequency: "月２〜３日",
  activity_time: "午後",
  available_day: "土日",
  motivation: "趣味で楽しく",
 original: "オリジナル曲"
  )
  band.band_members.create(user_id: readers[n].id, part_id: rand(1..6), role: "リーダー")
  band.band_members.create(user_id: members[n].id, part_id: rand(1..6), role: "メンバー")
end
