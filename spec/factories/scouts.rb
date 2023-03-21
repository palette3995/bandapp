FactoryBot.define do
  factory :scout do
    association :user
    message { "scoutmessage" }
  end
end
