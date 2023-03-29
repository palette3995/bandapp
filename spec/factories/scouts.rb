FactoryBot.define do
  factory :scout do
    association :user
    message { SecureRandom.alphanumeric(30) }
  end
end
