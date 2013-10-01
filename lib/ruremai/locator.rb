require 'set'
require 'uri'
require 'net/http'

module Ruremai
  module Locator
    autoload :Base,        'ruremai/locator/base'
    autoload :Rurema,      'ruremai/locator/rurema'
    autoload :RubyDocInfo, 'ruremai/locator/ruby_doc_info'

    class << self
      def locate(method, locales)
        locators_for(locales).each.with_object([]) {|locator, fallbacks|
          uri = locator.base_uri

          Net::HTTP.start uri.host, uri.port do |http|
            puts %(Start: #{uri}) if Ruremai.verbose

            locator.candidates(method).each do |uri|
              response = http.head(uri.path)

              puts %(#{response.code}: #{uri}) if Ruremai.verbose

              case response
              when Net::HTTPOK                            then return uri
              when Net::HTTPSuccess, Net::HTTPRedirection then fallbacks << uri
              end
            end
          end
        }.first
      end

      private

      def locators
        @locators ||= Set.new([Rurema, RubyDocInfo])
      end

      def locators_for(locales)
        locales.map(&:to_s).inject([]) {|memo, locale|
          memo.concat locators.select {|locator| locator.locale == locale }
        }
      end
    end
  end
end
