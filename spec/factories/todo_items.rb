FactoryBot.define do
  factory :todo_item do
    title { "Test Todo Item" }
    completed { false }
    association :todo
  end
end

