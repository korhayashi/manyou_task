FactoryBot.define do
  factory :labeling do
    id { 1 }
    task_id { 1 }
    label_id { 1 }
  end

  factory :second_labeling, class: Labeling do
    id { 2 }
    task_id { 2 }
    label_id { 2 }
  end
end
