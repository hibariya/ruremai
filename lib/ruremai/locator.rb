require 'uri'
require 'net/http'

module Ruremai
  module Locator
    autoload :Rurema, 'ruremai/locator/rurema'

    class Base
      class << self
        def locate(method)
          new(method).located
        end
      end

      attr_reader :name, :receiver, :owner

      def initialize(method)
        @method    = method
        @name      = method.name
        @receiver  = method.receiver
        @owner     = method.owner
      end

      def located
        candidates.detect {|uri| exist?(uri) }
      end

      def candidates
        []
      end

      private

      def exist?(uri, tries = 3)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        http.start {|h|
          case h.head(uri.path)
          when Net::HTTPSuccess, Net::HTTPRedirection
            true
          else
            false
          end
        }
      rescue Net::OpenTimeout => e
        if tries.zero?
          abort "Aborting due to #{e.class} (#{e.message})"
        else
          warn 'Retrying...'
          exist?(uri, tries - 1)
        end
      end

      # XXX can't care singleton method
      def method_owner
        owner.name ? owner : receiver
      end
    end
  end
end
