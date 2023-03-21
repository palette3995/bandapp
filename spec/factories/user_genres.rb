FactoryBot.define do
  factory :user_genre do
    association :user
    association :genre
  end
end
