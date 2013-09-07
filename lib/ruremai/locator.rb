require 'uri'
require 'net/http'

module Ruremai
  module Locator
    autoload :Base,        'ruremai/locator/base'
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
        #       follow redirect
        Net::HTTP.start(uri.host, uri.port) {|http|
          http.head(uri.path)
        }
      end
    end
  end
end
