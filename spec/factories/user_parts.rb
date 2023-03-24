FactoryBot.define do
  factory :user_part do
    association :user
    part { Part.all.sample }
  end
end
