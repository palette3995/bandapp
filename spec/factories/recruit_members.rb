FactoryBot.define do
  factory :recruit_member do
    association :band
    part_id { 6 }
    other_part { "test_other_part" }
    level { "初心者" }
    age { "20代まで" }
    sex { "男性" }
  end
end
