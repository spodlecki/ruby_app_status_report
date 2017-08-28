# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gemfile do
    association :ruby_app,
                factory: :ruby_app

    data do
      text = File.read( Rails.root.join('spec',
                                        'support',
                                        'Gemfile.lock.sample') )
      Gemfile.parse(text)
    end
  end
end
