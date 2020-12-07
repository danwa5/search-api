module Services
  module BaseService
    def self.included(target)
      target.extend ClassMethods
    end

    module InstanceMethods
      # Public: The called method by the service. The including class must implement this method.
      def call
        raise NotImplementedError
      end
    end

    module ClassMethods
      # Public: Initialize the service (method object) and make the call.
      #
      # args - The argument options that are implemented by the including class
      def call(*args)
        new(*args).call
      end
    end
  end
end
