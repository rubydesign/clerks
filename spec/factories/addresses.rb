# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :address do
    name {"Torsten Ruger"}
    street {"Högbenintie 30"}
    city {"10480 antskog"}
    country {"Suomi"}
    phone {"0407308052"}
  end
end
