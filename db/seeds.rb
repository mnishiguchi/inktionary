# frozen_string_literal: true

raise "Do not seed db in production" if Rails.env.production?

say = ->(msg) { puts(msg) unless Rails.env.test? }

delete_all_items = -> { ApplicationTable.scan.each(&:delete!) }

restart_server = -> { `touch #{Rails.root.join("tmp", "restart.txt")}` }

if Rails.env.development? || Rails.env.test?
  say["\n== Clearing DynamoDB Table #{ApplicationTable.table_name} =="]
  begin
    delete_all_items.call
  rescue Aws::DynamoDB::Errors::ResourceNotFoundException
    nil
  end

  say["\n== Restarting the app server =="]
  restart_server.call
end

say["\n== Preparing fake data =="]

# Limit the number of user etc so that there will be duplication in those columns.
user_ids = 10.times.map { Faker::Internet.safe_email }.uniq.sort
word_names = 30.times.map { Faker::Hacker.abbreviation }.uniq.sort
tag_names = 5.times.map { Faker::Color.color_name }.uniq.sort

say["user_ids: #{user_ids}"]
say["word_names: #{word_names}"]
say["tag_names: #{tag_names}"]

say["\n== Inserting data into DynamoDB table =="]

# Create word items
word_items = 50.times.map do
  FactoryBot.build(:word, word_name: word_names.sample, user_id: user_ids.sample)
            .tap(&:save)
            .tap { print "." }
end

# Some users vote for word items
5.times do
  Word::AddVote.call(
    user_id:   user_ids.sample,
    word_item: word_items.sample
  ).tap { print "." }
end

# Add tags on some word items
5.times do
  Word::AddTag.call(
    word_item: word_items.sample,
    tag_name:  tag_names.sample
  ).tap { print "." }
end

say["\nDone\n"]
