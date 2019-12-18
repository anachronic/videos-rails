FactoryBot.define do
  factory :video do
    name { Faker::Movie.quote }

    trait :with_image do
      file {
        fixture_file_upload(
          Rails.root.join('spec', 'factories', 'assets', 'pear.jpg'),
          'image/jpeg'
        )
      }
    end
  end
end
