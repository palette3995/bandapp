FactoryBot.define do
  factory :jpop, class: "Genre" do
    id { 1 }
    name { "J-POP" }
  end
  factory :anime, class: "Genre" do
    id { 2 }
    name { "アニメ" }
  end
  factory :jhiphop, class: "Genre" do
    id { 3 }
    name { "邦楽ヒップホップ/R&B/レゲエ" }
  end
  factory :jrock, class: "Genre" do
    id { 4 }
    name { "邦楽ロック" }
  end
  factory :jdance, class: "Genre" do
    id { 5 }
    name { "邦楽ダンス/エレクトロニカ" }
  end
  factory :vocaloid, class: "Genre" do
    id { 6 }
    name { "ボーカロイド" }
  end
  factory :kpop, class: "Genre" do
    id { 7 }
    name { "K-POP/ワールド・ミュージック" }
  end
  factory :wpop, class: "Genre" do
    id { 8 }
    name { "洋楽ポップ" }
  end
  factory :whiphop, class: "Genre" do
    id { 9 }
    name { "洋楽ヒップホップ/R&B/レゲエ" }
  end
  factory :wrock, class: "Genre" do
    id { 10 }
    name { "洋楽ロック" }
  end
  factory :wdance, class: "Genre" do
    id { 11 }
    name { "洋楽ダンス/エレクトロニカ" }
  end
  factory :enka, class: "Genre" do
    id { 12 }
    name { "歌謡曲/演歌" }
  end
  factory :jaz, class: "Genre" do
    id { 13 }
    name { "ジャズ" }
  end
  factory :classic, class: "Genre" do
    id { 14 }
    name { "クラシック" }
  end
  factory :other_music, class: "Genre" do
    id { 15 }
    name { "その他" }
  end
  factory :blank_genre, class: "Genre" do
    id { 16 }
    name { "未選択" }
  end
end
