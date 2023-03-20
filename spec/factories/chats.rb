FactoryBot.define do
  factory :chat do
    association :band
    association :user
  end
end
