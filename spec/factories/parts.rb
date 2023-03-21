FactoryBot.define do
  factory :vocal, class: "Part" do
    id { 1 }
    name { "ボーカル" }
  end

  factory :guitar, class: "Part" do
    id { 2 }
    name { "ギター" }
  end

  factory :bass, class: "Part" do
    id { 3 }
    name { "ベース" }
  end

  factory :drum, class: "Part" do
    id { 4 }
    name { "ドラム/パーカッション" }
  end

  factory :piano, class: "Part" do
    id { 5 }
    name { "キーボード/ピアノ" }
  end

  factory :other_inst, class: "Part" do
    id { 6 }
    name { "その他" }
  end

  factory :blank_part, class: "Part" do
    id { 7 }
    name { "未選択" }
  end
end
