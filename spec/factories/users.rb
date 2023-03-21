FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user-#{n}" }
    sequence(:email) { |n| "TEST#{n}@example.com" }
    password { "test01" }
    password_confirmation { "test01" }

    before(:create) { User.skip_callback(:create, :after, :create_parts_and_genres) }
    after(:create) { User.set_callback(:create, :after, :create_parts_and_genres) }
  end
end
