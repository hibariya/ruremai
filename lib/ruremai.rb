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

    def default_locales
      @locales ||= detect_default_locales
    end

    def default_locales=(names)
      @locales = Array(names)
    end

    def launch(method, locales = default_locales)
      if uri = Locator.locate(method, locales)
        Launchy.open uri.to_s
      else
        raise NoReferenceManualFound, method
      end
    end

    private

    def detect_default_locales
      /^ja_/ === ENV['LANG'] ? %w(ja en) : %w(en ja)
    end
  end
end
