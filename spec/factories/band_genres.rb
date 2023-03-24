FactoryBot.define do
  factory :band_genre do
    association :band
    genre { Genre.all.sample }
  end
end
