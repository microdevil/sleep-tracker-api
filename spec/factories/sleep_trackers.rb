FactoryBot.define do
  factory :sleep_tracker do
    user
    slept_at { Time.current - 8.hours }
    woke_up_at { Time.current }
  end
end
