module Ruremai
  module Locator
    autoload :Rurema, 'ruremai/locator/rurema'

    class Base
      class << self
        def locate(method)
          new(method).located
        end
      end

      attr_reader :name, :owner

      def initialize(method)
        @method = method
        @name   = method.name
        @owner  = method.owner
      end

      def located
        candidates.detect {|uri| exist?(uri) }
      end

      def candidates
        []
      end

      private

      def exist?(uri)
        Net::HTTP.start(uri.host, uri.port) {|http|
          response = http.head(uri.path)

          case response.code
          when *%w(200 301 302) # FIXME: others?
            true
          else
            false
          end
        }
      end
    end
  end
end
