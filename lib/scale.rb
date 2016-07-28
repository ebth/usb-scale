require 'scale/client'
require 'scale/output'
require 'scale/error/device_disconnected_error.rb'
require 'scale/error/device_read_error.rb'

module Scale
  class << self

    def new
      Scale::Client.new
    end

    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private = false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end

  end
end
