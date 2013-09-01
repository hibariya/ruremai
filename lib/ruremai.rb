require 'launchy'
require 'ruremai/version'
require 'ruremai/ext/method'
require 'ruremai/ext/object'

module Ruremai
  autoload :Locator, 'ruremai/locator'
  autoload :Mean,    'ruremai/mean'

  class NoReferenceManualFound < StandardError; end

  class << self
    attr_writer :locators

    def launch(method)
      if uri = locate(method)
        Launchy.open uri.to_s
      else
        raise NoReferenceManualFound
      end
    end

    def locate(method)
      locate_all(method).first
    end

    def locate_all(method)
      locators.map {|locator|
        locator.locate(method)
      }.compact
    end

    def locators
      @locators ||= [Locator::Rurema]
    end
  end
end
