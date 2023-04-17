FactoryBot.define do
  factory :user_genre do
    association :user
    genre { Genre.all.sample }
  end
end
