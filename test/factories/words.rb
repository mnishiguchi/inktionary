# frozen_string_literal: true

FactoryBot.define do
  factory :word do
    word_name { Faker::Hacker.abbreviation }
    explanation { Faker::Hacker.say_something_smart }
    user_id { Faker::Internet.safe_email }
    tags { "" }
    vote_count { 0 }

    # https://thoughtbot.com/blog/tips-for-using-factory-girl-without-an-orm
    initialize_with do
      new.tap do |instance|
        instance.assign_attributes(attributes)
      end
    end
  end
end
