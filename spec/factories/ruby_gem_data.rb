# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ruby_gem_datum do
    name { "gem#{generate(:uid)}" }
    versions []
  end
end
