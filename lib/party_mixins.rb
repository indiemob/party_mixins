# frozen_string_literal: true

require_relative "party_mixins/version"
require_relative "service_error"

# Party Mixins main class
module PartyMixins
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Contains class level method wrappers
  module ClassMethods
    def party_method(options = {})
      @party_method_options = {}.merge(options)
    end

    def party_methods
      @party_methods ||= {}
    end

    def build_options(method_name, response)
      {
        error_message: "[#{response.code}] #{response.body}"
      }.merge(party_methods[method_name])
    end

    private

    def method_added(method_name)
      if @party_method_options
        party_methods[method_name] = @party_method_options
        enhance!(method_name)
      end
      @party_method_options = nil
      super
    end

    def enhance!(method_name)
      this = self
      proxy = Module.new do
        define_method(method_name) do |*args, **kwargs|
          response = super(*args, **kwargs)
          options = this.build_options(method_name, response)
          raise ServiceError.new(response, options[:error_message]) unless response.success? || response.ok?

          response.parsed_response
        end
      end
      prepend proxy
    end
  end
end
