FactoryBot.define do
  factory :band do
    sequence(:name) { |n| "band-#{n}" }
    before(:create) { Band.skip_callback(:create, :after, :create_genres) }
    after(:create) { Band.set_callback(:create, :after, :create_genres) }
  end
end
