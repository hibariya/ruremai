require 'launchy'
require 'ruremai/version'
require 'ruremai/ext/method'
require 'ruremai/ext/object'

module Ruremai
  autoload :Locator, 'ruremai/locator'
  autoload :Mean,    'ruremai/mean'

  class NoReferenceManualFound < StandardError
    attr_reader :target

    def initialize(target_method)
      @target = target_method

      super "No reference manual found for #{target.inspect}"
    end
  end

  class << self
    attr_accessor :verbose
    attr_writer   :locators, :primary_locale

    def primary_locale
      @primary_locale ||= 'en'
    end

    def locators
      @locators ||= Locator.all
    end

    def launch(method, locale = primary_locale)
      if uri = locate(method, locale)
        Launchy.open uri.to_s
      else
        raise NoReferenceManualFound, method
      end
    end

    def locate(method, locale)
      ordered_locators(locale).each do |locator|
        next unless url = locator.locate(method)

        return url
      end

      nil
    end

    def ordered_locators(locale)
      locale = locale.to_s

      locators.partition {|locator|
        locator.locale == locale
      }.inject(:+)
    end
  end
end
