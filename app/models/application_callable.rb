# frozen_string_literal: true

class ApplicationCallable
  def self.call(*args)
    new(*args).call
  end

  def call
    raise NotImplementedError
  end
end
