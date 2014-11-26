FactoryGirl.define do
   factory :todo do
     sequence(:description, 100) { |n| "a description #{n}" }
     user
     created_at rand(14.days.ago..Time.zone.now)
   end
 end