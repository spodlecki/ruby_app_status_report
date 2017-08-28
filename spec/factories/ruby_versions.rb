# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ruby_version do
    version { generate(:version) }
    released Date.today
    notes_url 'https://www.ruby-lang.org/en/news/2017/03/22/ruby-2-4-1-released/'
  end
end
