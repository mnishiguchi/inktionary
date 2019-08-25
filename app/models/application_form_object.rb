# frozen_string_literal: true

class ApplicationFormObject
  include ActiveModel
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion
end
