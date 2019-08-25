# frozen_string_literal: true

def create_table
  ApplicationTable.create_table
end

# NOTE: It is difficult to test exact result due to the eventual consistency of dynamodb.
def delete_items
  ApplicationTable.scan.each(&:delete!)
end
