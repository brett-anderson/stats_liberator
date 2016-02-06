# From: http://brewhouse.io/blog/2014/04/30/gourmet-service-objects.html
module Service
  extend ActiveSupport::Concern

  # When a gourmet service object is invoked using Object.call(arg1, arg2, ...)
  # Initialize that object using all args
  included do
    def self.call(*args)
      new(*args).call
    end
  end
end
