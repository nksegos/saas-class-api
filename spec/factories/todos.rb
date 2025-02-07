FactoryBot.define do
  factory :todo do
    title { "Test Todo" }
    association :user
  end
end

