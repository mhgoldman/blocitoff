FactoryGirl.define do
   factory :list do
     sequence(:name, 100) { |n| "a name #{n}" }
     user
   end
 end