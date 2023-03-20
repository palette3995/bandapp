FactoryBot.define do
  factory :user_part do
    association :user
    association :part
  end
end
