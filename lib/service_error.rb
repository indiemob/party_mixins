# frozen_string_literal: true

# API Response Error Class
class ServiceError < StandardError
  attr_reader :code, :response
  def initialize(response, message = "Service responded with an error")
    super(message)
    @code = response.code
    @response = response
  end
end
