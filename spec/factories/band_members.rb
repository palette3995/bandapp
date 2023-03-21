FactoryBot.define do
  factory :band_member do
    association :band
    association :user
    role { "メンバー" }
  end
end
