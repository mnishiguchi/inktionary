# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    word_name { Faker::Hacker.abbreviation }
    word_id { build(:word).item_id }

    # https://thoughtbot.com/blog/tips-for-using-factory-girl-without-an-orm
    initialize_with do
      new.tap do |instance|
        instance.assign_attributes(attributes)
      end
    end
  end
end
