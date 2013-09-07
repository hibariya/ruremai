require 'uri'
require 'net/http'

module Ruremai
  module Locator
    autoload :Rurema,      'ruremai/locator/rurema'
    autoload :RubyDocInfo, 'ruremai/locator/ruby_doc_info'

    def self.all
      [Rurema, RubyDocInfo]
    end

    class Base
      class << self
        def locate(method)
          new(method).locate
        end

        def locale(name = nil)
          name ? @locale = name : @locale
        end
      end

      attr_reader :name, :receiver, :owner

      def initialize(method)
        @method    = method
        @name      = method.name
        @receiver  = method.receiver
        @owner     = method.owner
      end

      def locate
        candidates.detect {|uri| exist?(uri) }
      end

      def candidates
        []
      end

      private

      def exist?(uri)
        Net::HTTP.start(uri.host, uri.port) {|http|
          response = http.head(uri.path)

          case response
          when Net::HTTPSuccess, Net::HTTPRedirection
            true
          else
            false
          end
        }
      end

      # XXX can't care singleton method
      def method_owner_name
        owner.name ? owner.name : receiver.name
      end

      def ordered_method_types
        scored_method_types.sort_by {|_, score|
          score
        }.reverse.map {|type, _|
          type
        }
      end

      def scored_method_types
        has_singleton_methohd = owner.methods.include?(name)
        has_private_method    = owner.private_instance_methods.include?(name)
        has_instance_method   = owner.instance_methods.include?(name)

        {singleton_method: 0, instance_method: 0, module_function: 0}.tap {|t|
          t[:module_function]  += 1 if has_singleton_methohd  && has_private_method
          t[:singleton_method] += 1 if has_singleton_methohd  && !has_private_method
          t[:instance_method]  += 1 if !has_singleton_methohd && has_instance_method

          if receiver.is_a?(Module)
            t[:module_function]  += 1
            t[:singleton_method] += 1
          else
            t[:instance_method]  += 1
          end
        }
      end
    end
  end
end
