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
      options = build_options(method_name)
      proxy = Module.new do
        define_method(method_name) do |*args|
          response = super(*args)
          raise ServiceError.new(response, options[:error_message]) unless response.ok?

          response.parsed_response
        end
      end
      prepend proxy
    end

    def build_options(method_name)
      {
        error_message: "Service responded with an error"
      }.merge(party_methods[method_name])
    end
  end
end
