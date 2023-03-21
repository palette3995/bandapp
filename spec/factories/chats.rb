FactoryBot.define do
  factory :chat do
    association :band
    association :user
    message { SecureRandom.alphanumeric(500) }
  end
end
