# frozen_string_literal: true

module Services
  # Parenc class for all unrelated bussines logic services.
  class ApplicationService
    def self.call(*args)
      new(*args).call
    end

    def call
      raise 'Not implemented method'
    end
  end
end
