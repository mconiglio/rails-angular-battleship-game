FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password 'somepassword'
    password_confirmation 'somepassword'
  end
end
