FactoryBot.define do
  factory :recruit_member do
    association :band
    association :part
    level { "初心者" }
    age { "20代まで" }
    sex { "男性" }

  end
end
