FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :uid do |n|
    "uid#{n}"
  end

  sequence :version do |n|
    "1.1.#{n}"
  end
end
