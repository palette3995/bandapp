FactoryBot.define do
  factory :band do
    sequence(:name) { |n| "band-#{n}" }
  end
end
