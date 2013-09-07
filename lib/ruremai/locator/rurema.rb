require 'cgi'

module Ruremai
  module Locator
    class Rurema < Base
      URI_BASE = 'http://doc.ruby-lang.org/ja/'

      locale 'ja'

      def candidates
        uri_part    = [RUBY_VERSION, 'method', escape(method_owner_name)].join('/')
        type_chars  = {module_function: 'm', singleton_method: 's', instance_method: 'i'}
        method_name = escape(target.name.to_s)

        ordered_method_types.map {|type|
          type_char = type_chars[type]

          URI.parse("#{URI_BASE}#{uri_part}/#{type_char}/#{method_name}.html")
        }
      end

      private

      def escape(str)
        CGI.escape(str).gsub(/(%[\da-z]{2})/i) {|s|
          %(=#{s[1..-1].downcase})
        }
      end
    end
  end
end
