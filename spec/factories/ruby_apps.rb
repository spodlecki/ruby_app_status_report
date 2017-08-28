# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ruby_app do
    name { "Name #{generate(:uid)}" }
    repo_url { "git@gitlab.com:something/#{generate(:uid)}.git" }
    api_type 1
    ruby_version '1.8.7'

    trait :with_gemfile do
      after(:create) do |model|
        FactoryGirl.create(:gemfile, ruby_app: model)
      end

      after(:stub) do |model|
        FactoryGirl.build_stubbed(:gemfile, ruby_app: model)
      end
    end
  end
end
