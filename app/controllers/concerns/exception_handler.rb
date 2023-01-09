# frozen_string_literal: true

# Trap the exceptions we want to handle
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ArgumentError do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end
end
