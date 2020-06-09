FactoryBot.define do
  factory :label do
    id { 1 }
    name { 'A' }
    user_id { nil }
  end

  factory :second_label, class: Label do
    id { 2 }
    name { 'B' }
    user_id { nil }
  end
end
