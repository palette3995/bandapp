FactoryBot.define do
  factory :band_member do
    association :band
    association :user
    association :part
  end
end
