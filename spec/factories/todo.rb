FactoryGirl.define do
   factory :todo do
     sequence(:description, 100) { |n| "a description #{n}" }
     list
     created_at Random.new.rand(14.days.ago..Time.zone.now)
   end
 end