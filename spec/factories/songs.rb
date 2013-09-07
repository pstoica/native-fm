# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :song do
    location "MyString"
    url "MyString"
    lat 1.5
    long 1.5
    note "MyString"
  end
end
