FactoryBot.define do
  factory :band_member do
    association :band
    association :user
    role { "メンバー" }
    part_id { 6 }
    other_part { "test_other_part" }
  end
end
