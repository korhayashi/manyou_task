FactoryBot.define do
  factory :label do
    name { 'A' }
    user_id { nil }
  end

  factory :second_label, class: Label do
    name { 'B' }
    user_id { nil }
  end
end
