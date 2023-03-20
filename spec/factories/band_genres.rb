FactoryBot.define do
  factory :band_genre do
    association :band
    association :genre
  end
end
