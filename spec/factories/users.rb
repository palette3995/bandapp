FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user-#{n}" }
    sequence(:email) { |n| "TEST#{n}@example.com" }
    password { "test01" }
    password_confirmation { "test01" }
  end
end
