require 'uri'
require 'net/http'

module Ruremai
  module Locator
    autoload :Rurema,      'ruremai/locator/rurema'
    autoload :RubyDocInfo, 'ruremai/locator/ruby_doc_info'

    class << self
      attr_writer :available_locators

      def available_locators
        @available_locators ||= [Rurema, RubyDocInfo]
      end

      def locate(method, locales)
        ordered_locators(locales).each.with_object([]) {|locator, fallbacks|
          locator.candidates(method).each do |uri|
            response = head(uri)

            puts %(#{response.code}: #{uri}) if Ruremai.verbose

            case response
            when Net::HTTPOK
              return uri
            when Net::HTTPSuccess, Net::HTTPRedirection
              fallbacks << uri
            end
          end
        }.first
      end

      def ordered_locators(locales)
        locales.map(&:to_s).inject([]) {|memo, locale|
          memo + available_locators.select {|locator|
            locator.locale == locale
          }
        }
      end

      private

      def head(uri)
        # TODO: reuse existing session
        Net::HTTP.start(uri.host, uri.port) {|http|
          http.head(uri.path)
        }
      end
    end

    class Base
      class << self
        def candidates(method)
          new(method).candidates
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

      def candidates
        []
      end

      private

      # XXX can't care singleton method
      def method_owner_name
        owner.name ? owner.name : receiver.name
      end

      def ordered_method_types
        method_types_with_score.sort_by {|_, score|
          score
        }.reverse.map {|type, _|
          type
        }
      end

      def method_types_with_score
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
