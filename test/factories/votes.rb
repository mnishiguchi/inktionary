# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    user_id { Faker::Internet.safe_email }
    word_id { build(:word).item_id }

    # https://thoughtbot.com/blog/tips-for-using-factory-girl-without-an-orm
    initialize_with do
      new.tap do |instance|
        instance.assign_attributes(attributes)
      end
    end
  end
end
